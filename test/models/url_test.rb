require "test_helper"

describe Url do
  let(:url) { Url.new }

  it "must be valid" do
    value(url).must_be :valid?
  end
end
