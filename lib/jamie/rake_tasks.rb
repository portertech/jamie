# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2012, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rake/tasklib'

require 'jamie'

module Jamie

  # Jamie Rake task generator.
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  class RakeTasks < ::Rake::TaskLib

    # Creates Jamie Rake tasks and allows the callee to configure it.
    #
    # @yield [self] gives itself to the block
    def initialize
      @config = Jamie::Config.new
      yield self if block_given?
      define
    end

    private

    attr_reader :config

    def define
      namespace "jamie" do
        config.instances.each do |instance|
          desc "Run #{instance.name} test instance"
          task instance.name { instance.test(:always) }
        end

        desc "Run all test instances"
        task "all" => config.instances.map { |i| i.name }
      end
    end
  end
end
