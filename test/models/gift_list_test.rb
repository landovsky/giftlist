require "test_helper"

describe GiftList do
  let(:gift_list) { GiftList.new }

  it "must be valid" do
    value(gift_list).must_be :valid?
  end
end
