# Carousel
#
# @example
#
# .js-carousel-box { position: relative; overflow: hidden; }
# .js-carousel-inner { position: absolute; }
# .js-carousel-inner .item { display: none; position: absolute; }
# .js-carousel-inner .active { display: block; }
#
# <div class="banner_slide js-carousel-box">
#   <ul class="slide_list js-carousel-inner">
#     <li class="item active">
#       <a href="#"><img width="740" height="260" src="#" /></a>
#     </li>
#     <li class="item">
#       <a href="#"><img width="740" height="260" src="#" /></a>
#     </li>
#   </ul>
# </div>
#
# @author ApolloPY <ApolloPY@Gmail.com>

# CLASS DEFINITION

class Carousel
  constructor: (element, options) ->
    @options = options
    @_current = 0
    @_sliding = false
    @_paused = false
    @_timer = null

    $element = $(element)
    @rect = $element.width()
    @$inner = $element.find(@options.inner_selector)
    @$items = $element.find(@options.items_selector)

    if @options.pause
      $element.on 'mouseenter.py.carousel', =>
        @pause true
      .on 'mouseleave.py.carousel', =>
        @pause false

    @start() if @options.auto

    @$indicators = $(@options.indicators_selector).each (i, ele) =>
      $(ele).on 'click.py.carousel', => @show i
    $(@options.control_next_selector).on 'click.py.carousel', => @next()
    $(@options.control_prev_selector).on 'click.py.carousel', => @prev()

  # .show( index [, is_prev (default: false) ] )
  show: (index) ->
    is_prev = if arguments[1] is true then true else false

    return false if @_sliding
    return false if !index? or index is @_current

    @_sliding = true

    @$indicators.eq(@_current).removeClass('active')
    @$indicators.eq(index).addClass('active')

    $next = @$items.eq(index)
    $next.addClass('active')
    $next.css 'left', if is_prev then "-#{@rect}px" else "#{@rect}px"

    @$inner.animate
      left : (if is_prev then @rect else -@rect),
      @options.duration, =>
        $next.css 'left', '0px'
        @$inner.css 'left', '0px'
        @$items.eq(@_current).removeClass('active')
        @_current = index
        @_sliding = false

    false

  prev: ->
    index = if @_current - 1 < 0 then @$items.length - 1 else @_current - 1
    @show index, true

  next: ->
    index = if @_current + 1 > @$items.length - 1 then 0 else @_current + 1
    @show index

  start: ->
    @stop()
    @_paused = false
    @_timer = setInterval =>
      @next() unless @_paused
    , @options.delay

  stop: ->
    @_timer = clearInterval @_timer if @_timer

  pause: (paused) ->
    @_paused = paused

# PLUGIN DEFINITION

$.fn.carousel = (options) ->
  defaults =
    inner_selector : '.js-carousel-inner'
    items_selector : '.js-carousel-inner .item'
    indicators_selector : '.js-carousel-indicators .item'
    control_next_selector : '.js-carousel-control.btn_next'
    control_prev_selector : '.js-carousel-control.btn_prev'
    delay : 6000
    duration : 500
    auto : true
    pause : true
  options =  $.extend defaults, options

  @.each ->
    $this = $(this)
    unless $this.data('py.carousel')
      $this.data('py.carousel', new Carousel(this, options))

