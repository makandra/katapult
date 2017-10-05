$(() => {
  if ($(document.body).data('environment') === 'test') {
    // Disable animations in tests
    up.motion.config.enabled = false

    // When revealing elements, don't animate the scrolling
    up.layout.config.duration = 0
  }
})
