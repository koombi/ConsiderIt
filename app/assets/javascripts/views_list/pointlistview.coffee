class ConsiderIt.PointListView extends Backbone.CollectionView

  @itemView : ConsiderIt.PointView
  @childClass : 'point_in_list'

  listSelector : '.point_list'


  initialize : (options) ->
    super
    @location = options.location
    @proposal = options.proposal
    _.bindAll this
    ConsiderIt.router.on('route:PointDetails', @show_point_details_handler)

  render : () ->
    super

  # Returns an instance of the view class
  getItemView: (point)->
    new ConsiderIt.PointListView.itemView
      model: point
      collection: @collection
      proposal : @proposal
      attributes : 
        class : "#{ConsiderIt.PointListView.childClass} #{ConsiderIt.PointListView.childClass}_#{@location} #{if point.attributes.is_pro then 'pro' else 'con' }"
        'data-id': "#{point.cid}"
        includers : "#{point.get('includers')}"

  show_point_details_handler : (long_id, point_id) ->
    if @$el.is(':visible') && @proposal.model.get('long_id') == long_id
      point = @collection.get(point_id)
      if point?
        @getViewByModel(point).show_point_details_handler()


class ConsiderIt.PaginatedPointListView extends ConsiderIt.PointListView

  @pagingTemplate : _.template($('#tpl_pointlistpagination').html())
  _rendered : false

  initialize : (options) ->
    super

  render : () ->
    super
    # e = new Error('dummy');
    # stack = e.stack.replace(/^[^\(]+?[\n$]/gm, '')
    #   .replace(/^\s+at\s+/gm, '')
    #   .replace(/^Object.<anonymous>\s*\(/gm, '{anonymous}()@')
    #   .split('\n');
    # console.log(stack);

    @collection.info()
    if @$el.find('#pagination').length == 0 then @$el.append('<div id="pagination">')

    @repaginate()

    @listenTo @collection, 'reset', () => @repaginate()



  onAdd : (model) ->
    super
    @collection.pager()

  onRemove : (model) ->
    super
    @collection.pager()

  repaginate : ->
    @$el.find('#pagination').html(ConsiderIt.PaginatedPointListView.pagingTemplate({
      start_record : @collection.information.startRecord
      end_record : @collection.information.endRecord
      total_records : @collection.information.totalRecords
    })) 

  events : 
    'click .pager.forward' : 'forward'
    'click .pager.backward' : 'backward'

  forward : (ev) -> 
    @collection.nextPage()
    #@repaginate()

  backward : (ev) ->
    @collection.previousPage()
    #@repaginate()

