`import Ember from 'ember'`

PostsNewController = Ember.Controller.extend
  title: ''
  body: ''

  actions:
    submit: ->
      @store.createRecord('post',
        title: @get('title')
        body: @get('body')
      ).save().then(
        @transitionTo('posts')
      )

`export default PostsNewController`
