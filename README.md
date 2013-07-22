# Carousel

  A carousel plugin for jQuery. 

## Development

  $ sudo npm install -g coffee-script

## Example

### add JavaScript

```html
<script src="vendor/jquery.1.10.1.min.js"></script>
<script src="carousel.js"></script>
```

### basic HTML

```html
<div class="js-carousel-box">
  <ul class="js-carousel-inner">
    <li class="item active">...</li>
    <li class="item">...</li>
    <li class="item">...</li>
    <li class="item">...</li>
  </ul>
</div>
```

### add CSS

```css
.js-carousel-box { 
  position: relative;
  overflow: hidden;
  /* adjust these to your needs */
  width: 740px;
  height: 260px;
}
.js-carousel-inner {
  position: absolute;
}
.js-carousel-inner .item {
  display: none;
  position: absolute;
}
.js-carousel-inner .active {
  display: block;
}
```

### setup Carousel

```html
<script>
  $('.js-carousel-box').carousel(/*options*/);
</script>
```
