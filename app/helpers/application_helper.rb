module ApplicationHelper

  def spaces(x)
    str = x.to_i.to_s.reverse
    str.gsub!(/([0-9]{3})/, "\\1 ")
    return str.gsub(/,$/, '').reverse
  end

  def get_url_str (item, site)
    (item.urls & site.urls).first
  end

  def find_violating_urls(site, group)
    #Url.joins(:site, item: :group).where(violator: true, site: site, items: {'group_id'=> group}).order('items.name ASC')


    Rails.cache.fetch([site, group, 'url']) do
      Url.joins(:site, item: :group).where(violator: true, site: site, items: {'group_id'=> group}).order('items.name ASC')
    end
  end

  def sortable(column, search)
    direction = params[:sort] == column && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to column, :sort=>column, :item_search=> search, :direction => direction
  end
end
