require "test_helper"

describe Gift do
  let(:gift) { Gift.new }

  it "must be valid" do
    value(gift).must_be :valid?
  end
end
