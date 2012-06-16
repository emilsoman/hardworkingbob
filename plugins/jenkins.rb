module Jenkins
  class Path
    include Basil::Utils
    include Basil::Logging

    # add an accessor method +method+ available in the api's json at
    # +key+. if +conv+ is passed, it will be called on the value before
    # returning it.
    def self.def_accessor(method, key, conv = nil)
      conversions[method] = conv

      self.class_eval %{
        def #{method}
          value = json['#{key}'] # may be nil
          conv  = self.class.conversions[#{method.inspect}]

          (value && conv) ? conv.call(value) : value
        end
      }
    end

    # hold the lambdas described above
    def self.conversions
      @conversions ||= {}
    end

    def path
      raise "Subclass must implement"
    end

    def url
      "http://#{Basil::Config.jenkins['host']}#{path}"
    end

    def json
      unless @json
        opts = Basil::Config.jenkins
        opts['path'] = "#{path}api/json"

        @json = get_json(opts)
      end

      @json
    end
  end

  class Job < Path
    def_accessor :passing?,              'color',               lambda { |v| v =~ /blue/ }
    def_accessor :failing?,              'color',               lambda { |v| v =~ /red/ }
    def_accessor :aborted?,              'color',               lambda { |v| v =~ /aborted/ }
    def_accessor :disabled?,             'color',               lambda { |v| v =~ /disabled/ }
    def_accessor :builds,                'builds',              lambda { |v| v.map {|h| h['number']} }
    def_accessor :health_report,         'healthReport',        lambda { |v| v.map {|h| h['description']}.join("\n") }
    def_accessor :next_build_number,     'nextBuildNumber'
    def_accessor :last_successful_build, 'lastSuccessfulBuild', lambda { |v| v['number'] rescue nil }

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def path
      "/job/#{name}/"
    end

    def status
      return 'build is green!'    if passing?
      return 'last build failed.' if failing?
      return 'last build aborted' if aborted?
      return 'currently disabled' if disabled?

      'current status unknown'
    end
  end

  class Build < Path
    def_accessor :building?,  'building'
    def_accessor :duration,   'duration'
    def_accessor :result,     'result'
    def_accessor :fail_count, 'actions',   lambda { |v| (v[4]["failCount"] rescue '?') || '?' }
    def_accessor :culprits,   'culprits',  lambda { |v| v.map {|h| h['fullName']}.join(', ') }
    def_accessor :committers, 'changeSet', lambda { |v| v['items'].map {|h| h['user']}.uniq.join(', ') }

    attr_reader :name, :number

    def initialize(name, number)
      @name, @number = name, number
    end

    def path
      "/job/#{name}/#{number}/"
    end
  end
end

Basil.check_email(/jenkins build is back to normal : (\w+) #(\d+)/i) do
  name, number = @match_data.captures

  build = Jenkins::Build.new(name, number)

  set_chat('Dev/Arch + No more broken builds')

  says do |out|
    out << "(dance) #{build.name} is back to normal"
    out << "Thanks go to #{build.committers}!"
  end
end

Basil.check_email(/build failed in Jenkins: (\w+) #(\d+)/i) do
  name, number = @match_data.captures

  build = Jenkins::Build.new(name, number)

  set_chat('Dev/Arch + No more broken builds')

  says do |out|
    out << "(headbang) #{build.name} ##{build.number} failed!"
    out << "#{build.fail_count} failure(s). Culprits identified as #{build.culprits}."
    out << "Please see #{build.url} for more details."
  end
end

#Basil.respond_to('jenkins') do
#
# TODO: /api/json stopped working for me :(
#
#end

Basil.respond_to(/^jenkins (\w+)/) {

  job = Jenkins::Job.new(@match_data[1])

  says do |out|
    out << "#{job.name}: #{job.status}"
    out << job.health_report
  end

}.description = 'retrieves info on a specific jenkins job'

Basil.respond_to(/^who broke (.+?)\??$/) {

  job = Jenkins::Job.new(@match_data[1])

  if job.passing?
    return says "#{job.name} is currently green!"
  end

  build = Jenkins::Build.new(job.name, job.builds.last)

  says do |out|
    out << "The last completed build was #{build.number}"
    out << "Culprits are #{build.culprits}."
  end

}.description = 'tells you what commits lead to the first broken build'
