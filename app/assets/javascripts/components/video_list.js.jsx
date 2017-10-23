var VideoList = React.createClass({
  propTypes: {
    data: React.PropTypes.array,
  },

  render: function() {

    var videoNodes = this.props.data.map(function (video) {
      return (
        <Video title={video.title} vimeoId={video.vimeo_id} />
      );
    });

    return (
      <div className="videos">
        {videoNodes}
      </div>
    );
  }
});
