# This class represents a Marathon HealthCheck.
# See https://mesosphere.github.io/marathon/docs/health-checks.html for full details.
class Marathon::HealthCheck < Marathon::Base

  DEFAULTS = {
      :gracePeriodSeconds => 300,
      :intervalSeconds => 60,
      :maxConsecutiveFailures => 3,
      :path => '/',
      :portIndex => 0,
      :protocol => 'HTTP',
      :timeoutSeconds => 20
  }

  ACCESSORS = %w[ command gracePeriodSeconds intervalSeconds maxConsecutiveFailures
                  path portIndex protocol timeoutSeconds ignoreHttp1xx ]

  # Create a new health check object.
  # ++hash++: Hash returned by API.
  def initialize(hash)
    super(Marathon::Util.merge_keywordized_hash(DEFAULTS, hash), ACCESSORS)
    Marathon::Util.validate_choice(:protocol, protocol, %w[HTTP TCP COMMAND HTTPS MESOS_HTTP MESOS_HTTPS MESOS_TCP])
  end

  def to_s
    if protocol == 'COMMAND'
      "Marathon::HealthCheck { :protocol => #{protocol} :command => #{command} }"
    elsif %w[HTTP HTTPS MESOS_HTTP MESOS_HTTPS].include? protocol
      "Marathon::HealthCheck { :protocol => #{protocol} :portIndex => #{portIndex} :path => #{path}" + (%w[HTTP HTTPS].include? protocol and !ignoreHttp1xx.nil? ? " :ignoreHttp1xx => #{ignoreHttp1xx}" : '') + " }"
    else
      "Marathon::HealthCheck { :protocol => #{protocol} :portIndex => #{portIndex} }"
    end
  end

end