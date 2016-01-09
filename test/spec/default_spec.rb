#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe 'cheftie' do
  subject { chef_run.poise_service('myapp').provider_for_action(:enable) }
  before do
    begin
      PoiseService::ServiceProviders::Base.remove_class_variable(:@@service_resource_hints)
    rescue NameError
      # This space left intentionally blank.
    end
    allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return([:systemd, :upstart, :debian])
  end

  context 'with default provider' do
    recipe(subject: false) do
      poise_service 'myapp'
    end

    it { is_expected.to be_a PoiseMonit::ServiceProviders::Monit }
  end # /context with default provider

  context 'with provider_no_auto' do
    recipe(subject: false) do
      poise_service 'myapp' do
        provider_no_auto 'monit'
      end
    end

    it { is_expected.to be_a PoiseService::ServiceProviders::Systemd }
  end # /context with provider_no_auto
end
