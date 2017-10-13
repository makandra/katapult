const DEFAULT_TARGET = '.content'

up.macro('[modal-link]', function($link) {
  let target = $link.attr('modal-link') || DEFAULT_TARGET
  let attrs = {
    'up-modal': target,
    'up-preload': '',
    'up-instant': '',
  }

  // It feels wrong for a button
  if ($link.is('.btn:not(.btn-link)')) {
    delete attrs['up-instant']
  }

  $link.attr(attrs)
})
