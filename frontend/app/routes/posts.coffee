`import Ember from 'ember'`

PostsRoute = Ember.Route.extend
  model: (params) ->
    @store.find('post')

`export default PostsRoute`
