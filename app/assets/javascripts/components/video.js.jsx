var Video = React.createClass({
  propTypes: {
    title: React.PropTypes.string,
    vimeoId: React.PropTypes.node
  },

  render: function() {
    var src="//player.vimeo.com/video/" + this.props.vimeoId + "?byline=0&portrait=0";
    return (
      <div class="row">
        <div class="col-md-12">
          <h3>{this.props.title}</h3>
          <iframe src={src} width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
        </div>
      </div>
    );
  }
});
