require 'spec_helper'

describe Travis::Notification::Instrument::Event::Handler::Hipchat do
  include Travis::Testing::Stubs

  let(:build)     { stub_build(:config => { :notifications => { :hipchat => 'hipchat_room' } }) }
  let(:handler)   { Travis::Event::Handler::Hipchat.new('build:finished', build) }
  let(:publisher) { Travis::Notification::Publisher::Memory.new }
  let(:event)     { publisher.events[1] }

  before :each do
    Travis::Notification.publishers.replace([publisher])
    handler.stubs(:handle)
    handler.notify
  end

  it 'publishes a payload' do
    event.except(:payload).should == {
      :message => "travis.event.handler.hipchat.notify:completed",
      :uuid => Travis.uuid
    }
    event[:payload].except(:payload).should == {
      :event => 'build:finished',
      :targets => ['hipchat_room'],
      :msg => 'Travis::Event::Handler::Hipchat#notify(build:finished) for #<Build id=1>',
      :repository => 'svenfuchs/minimal',
      :request_id => 1,
      :object_id => 1,
      :object_type => 'Build'
    }
    event[:payload][:payload].should_not be_nil
  end
end
