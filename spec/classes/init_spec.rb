require 'spec_helper'
describe 'oracletasks' do

  context 'with defaults for all parameters' do
    it { should contain_class('oracletasks') }
  end
end
