class Site < ActiveRecord::Base
  has_many :urls
  has_many :items, through: :urls
  has_and_belongs_to_many :groups

  def check_for_violation
    urls = self.urls.where(violator: true)
    self.violator = urls.empty? ? false : true
    self.save
    p "--", self.name, urls.count, self.violator
    #if !urls.empty?
    #  self.violator = true
    #  if self.out_of_ban_time.nil? || (Time.now > self.out_of_ban_time) #no ban before, or violator with ban time expired
    #    self.out_of_ban_time = Time.now + 1.days
    #  end
    #else
    #  if !self.out_of_ban_time.nil? && (Time.now > self.out_of_ban_time) #ban expired, no violations
    #    self.violator = false
    #    self.out_of_ban_time = nil
    #  end
    #end
    #if self.changed?
    #  self.save
    #end
  end

  def get_violating_urls
    Rails.cache.fetch([self, 'violators']){self.urls.where(violator: true)}
  end

  def get_items
    Rails.cache.fetch([self, 'items']){self.items}
  end

  def get_urls
    Rails.cache.fetch([self, 'urls']){self.urls}
  end

  def get_group_name
    Rails.cache.fetch([self, 'group_name']){self.groups[0].name}
  end

  def find_violating_urls(group)
    Rails.cache.fetch([self, group, 'urls']) do
      urls = site.urls.where(violator: true).find_all { |url| url.item.get_group_name == group.name }
      urls = urls.sort_by {|url| url.item.name}
    end
  end

end
