module ApplicationHelper

  def spaces(x)
    str = x.to_i.to_s.reverse
    str.gsub!(/([0-9]{3})/, "\\1 ")
    return str.gsub(/,$/, '').reverse
  end

  def find_violating_urls(site, group)
    Url.joins(:site, item: :group).where(violator: true, site: site, items: {'group_id'=> group}).order('items.name ASC')


    #Rails.cache.fetch([site.cache_key, group.cache_key, 'url']) do
    #  urls = site.urls.where(violator: true).find_all { |url| url.item.get_group_name == group.name }
    #  p urls.count
    #  urls = urls.sort_by {|url| url.item.name}

    #end
  end


end
