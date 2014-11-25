require 'rails_helper'

RSpec.describe Post, :type => :model do
  subject { FactoryGirl.create(:post) }
  it { expect(subject.title).to eq "MyString" }
end
