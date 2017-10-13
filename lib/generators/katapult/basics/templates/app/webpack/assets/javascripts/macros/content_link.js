const DEFAULT_TARGET = '.content'

up.macro('[content-link]', ($link) => {
  let target = $link.attr('content-link') || DEFAULT_TARGET
  let attrs = {
    'up-target': target,
    'up-preload': '',
    'up-instant': '',
  }

  // It feels wrong for a button
  if ($link.is('.btn:not(.btn-link)')) {
    delete attrs['up-instant']
  }

  $link.attr(attrs)
})
