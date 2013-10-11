class Site < ActiveRecord::Base
  has_many :urls
  has_many :items, through: :urls
  has_and_belongs_to_many :groups

  def check_for_violation
    urls = self.urls.where(violator: true)
    if !urls.empty?
      self.violator = true
      if self.out_of_ban_time.nil? || (Time.now > self.out_of_ban_time) #no ban before, or violator with ban time expired
        self.out_of_ban_time = Time.now + 1.days
      end
    else
      if !self.out_of_ban_time.nil? && (Time.now > self.out_of_ban_time) #ban expired, no violations
        self.violator = false
        self.out_of_ban_time = nil
      end
    end
      self.save
      self.touch
  end
end
