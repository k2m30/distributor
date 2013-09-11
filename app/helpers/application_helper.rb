module ApplicationHelper
  def add_url_to_item (url, item)
    new_url = Url.new
    new_url.url = url
    new_url.item = item
    new_url.save
    redirect_to edit_item_path (item)
  end

  def link_to_add_fields_old(name, f, association)
    # debugger
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def link_to_add_fields(name, f, association)
    # debugger
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    debugger
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end


  def spaces(x)
    str = x.to_i.to_s.reverse
    str.gsub!(/([0-9]{3})/,"\\1 ")
    return str.gsub(/,$/,"").reverse
  end


end
