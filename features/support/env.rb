PROJECT_ROOT_PATH = File.dirname(File.dirname(File.dirname(__FILE__)))
require 'middleman-core'
require 'middleman-core/step_definitions'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman-deploy')
