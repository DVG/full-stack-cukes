`import DS from 'ember-data'`

Post = DS.Model.extend
  title: DS.attr()
  body: DS.attr()

`export default Post`
