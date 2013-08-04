_ = window.Underscore
bn = window.Backbone

DEGREE = Math.PI / 180
document = window.document

isCanvasSupported = ->
  elem = document.createElement 'canvas'
  !!(elem.getContext && elem.getContext '2d')

fakeContext = ->
  @_transformMatrix = [1, 0, 0, 1, 0, 0]
  @_transformStack = []
  @_scale = [1, 1]
  @_rotate = 0

  Object.defineProperty @, 'currentTransform',
    get: -> @_transformMatrix

  Object.defineProperty @, 'currentMatrixInverse',
    get: ->
      m = @_transformMatrix
      a = m[0]; b = m[1]; c = m[2]; d = m[3]; e = m[4]; f = m[5]

      ad_bc = a * d - b * c
      bc_ad = b * c - a * d

      [
        d / ad_bc
        b / bc_ad
        c / bc_ad
        a / ad_bc
        (d * e - c * f) / bc_ad
        (b * e - a * f) / ad_bc
      ]
  @

Canon = w.Canon = bn.View.extend

  tagName: 'canvas'
  className: 'canon-js'

  initialize: (options) ->

    if not isCanvasSupported()
      throw 'Canvas is not supported'

    if not bn
      throw 'BackboneJS required'

    do @_initCanvas

    @ctx = @el.getContext '2d'

    @items = new bn.Collection
    @itemList = new bn.Collection

    @_bindEvents @items

  _initCanvas: ->



  _bindEvents: (collection) ->

    collection.on 'add', (item) =>

      path = collection.get('_path')
      if path
        path = path + '.' + item.get('name')
      else
        path = item.get('name')

      item.set '_path',  path
      @bindEvents item

    _.extend @, options



# Base Canon Element. Other elements should inherite from this one.
Canon.Element = bn.Model.extend

  initialize: (options, items...) ->
    @items = new Backbone.Collection items or [];
    @__defineGetter__ 'length', () =>
      @items.length
    @

  bringToFront: (item) ->
    @remove item
    @unshift item

  bringOnBack: (item) ->
    @remove item
    @push item

  add: (models) ->
    @items.add models

  remove: (models) ->
    @items.remove models

  push: (args...) ->
    @items.push args...

  pop: (args...) ->
    @items.pop args...

  unshift: (args...) ->
    @items.unshift args...

  shift: (args...) ->
    @items.shift args...

  slice: (args...) ->
    @items.slice args...

  at: (index) ->
    @items.at index

  where: (args...) ->
    @items.where args...

  findWhere: (attrs) ->
    @items.findWhere attrs

  sort: (args...) ->
    @items.sort args...

  pluck: (attr) ->
    @items.pluck attr
