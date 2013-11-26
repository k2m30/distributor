class Log < ActiveRecord::Base
  belongs_to :site

  def url
    self.name_found
  end

  def url=(name)
    self.name_found = name
    self.save
  end

  def names(current_user)
    return nil if self.message.nil?
    group_found = nil
    current_user.groups.each do |group|
      group_found = group if self.message.downcase.include?(group.name.downcase)
    end
    if group_found.nil?
      current_user.get_all_items_json
    else
      group_found.items.order(:name).pluck(:name).to_json
    end

  end

end