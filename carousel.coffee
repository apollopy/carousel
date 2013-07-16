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
    $element = $(element)
    @options = options

    @rect = $element.width()
    @$inner = $element.find(@options.inner_selector)
    @$items = $element.find(@options.items_selector)
    @$indicators = $element.find(@options.indicators_selector)

    @_current = 0
    @_sliding = false
    @_timer = null

    @start() if @options.auto

  # .show( index [, is_prev (default: false) ] )
  show: (index) ->
    is_prev = if arguments[1] is true then true else false

    return false if @_sliding
    return false if index is @_current

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
    @_timer = setInterval =>
      @next()
    , @options.delay

  stop: ->
    @_timer = clearInterval @_timer if @_timer

# PLUGIN DEFINITION

$.fn.carousel = (options) ->
  defaults =
    inner_selector : '.js-carousel-inner'
    items_selector : '.js-carousel-inner .item'
    indicators_selector : '.js-carousel-indicators .item'
    delay : 6000
    duration : 500
    auto : true
  options =  $.extend defaults, options

  @.each ->
    $this = $(this)
    data = $this.data('py.carousel')
    unless data
      $this.data('py.carousel', (data = new Carousel(this, options)))

