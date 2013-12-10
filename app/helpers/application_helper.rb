module ApplicationHelper

  def spaces(x)
    str = x.to_i.to_s.reverse
    str.gsub!(/([0-9]{3})/, "\\1 ")
    return str.gsub(/,$/, '').reverse
  end

  def get_price_str (item, site)
    common_url = item.urls & site.urls
    if !(common_url).empty?
      return common_url.first.price.to_s
    else
      return '-'
    end
  end

  def find_violating_urls(site, group)
    #Url.joins(:site, item: :group).where(violator: true, site: site, items: {'group_id'=> group}).order('items.name ASC')


    Rails.cache.fetch([site, group, 'url']) do
      Url.joins(:site, item: :group).where(violator: true, site: site, items: {'group_id'=> group}).order('items.name ASC')
    end
  end


end
