class Gift < ApplicationRecord
  belongs_to :list
  belongs_to :donor, :class_name => 'User', :foreign_key => 'user_id', optional: true
  has_many :urls, dependent: :destroy

  validates_presence_of :list
  validates :name, presence: { message: "něco si přeju, ale jak se to jen řekne..." }

  scope :recent, -> { where("created_at > ?", 2.minutes.ago) }

  after_create :notify_donors

  def associate_to_list(list_id)
    if List.find_by(id: list_id) == nil
      return false
    else
      self.list = list_id
    end
  end

  def taken?(id=0)
    return false if user_id.blank?
    return "self" if user_id == id
    return true if !user_id.blank?
  end

  def take(user_id)
    self.donor = User.id(user_id)
    self.save
    UserMailer.delay(run_at: 10.minutes.from_now.localtime, strategy: :delete_previous_duplicate ).reservations_email(user_id)
  end

  def untake(user_id)
    self.donor = nil
    self.save
    UserMailer.delay(run_at: 10.minutes.from_now.localtime, strategy: :delete_previous_duplicate ).reservations_email(user_id)
  end

  #TODO optimize: 3 selecty na odbavení této metody, možná dlouhý join (až bude víc dat)
  def self.authentic?( options = {} )
    gift_id = options[:gift_id].to_i if options[:gift_id]
    user_id = options[:user_id] if options[:user_id]

    return false if gift_id == 0
    @gift = self.find_by(id: gift_id)
    return false if @gift == nil #gift does not exist
    return false if !@gift.authorized_users.include?(user_id)
    @gift
  end

  def authorized_users
    @ids = []
    @ids << user_id if user_id != nil # dárce (může být nil)
    @list = List.eager_load(:invitees).find_by(id: self.list_id)
    @ids << @list.user_id # vlastník seznamu
    @list.invitees.map(&:id).each do |n| @ids << n end # pozvaní do seznamu
    @ids.uniq
  end

  def self.id(id)
    find_by(id: id)
  end

  def container_id
    "gift_cont#{id}"
  end

  def collapse_id
    "gift#{id}"
  end

  def panel_style
    if taken?
      "default"
    else
      "success"
    end
  end

  def taken_badge
    "<span class=\"label label-default\" style=\"position: relative; left: 5px; bottom: 2px\">zabráno</span>".html_safe if taken?
  end

  def notify_donors
    return if list.invitees.blank?
    list.invitees.each do |invitee|
      # TODO: udelat vyber token/bezna url dynamicky
      # TODO: optimalizovat - pri desitkach invitees to muze chvilku trvat
      token = invitee.token_for_list(list_id: list.id, n: 10)
      UserMailer.delay.new_gifts_email(recipient: invitee, token: token, gift: self)
    end
  end
end
