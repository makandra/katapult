module UnpolyHelper

  def content_link_to(*args, **options, &block)
    target = options.delete(:target) || ''
    link_to *args, **options.merge('content-link': target), &block
  end

  def modal_link_to(*args, **options, &block)
    target = options.delete(:target) || ''
    link_to *args, **options.merge('modal-link': target), &block
  end

end
