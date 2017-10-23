var StudentPerformanceTable = React.createClass({

  getInitialState: function () {
    return {
      updateable: false,
      selectedPerformance: null,
      standards: []
    }
  },

  componentDidMount: function () {
    $.getJSON(this.props.performancesPath).then(function (state) {
      state.performances = state.standards.reduce(function (result, standard) {
        return result.concat(standard.performances)
      }, [])
      if (state.updateable) {
        state.selectedPerformance = state.performances[0]
      }
      this.setState(state)
      if (state.updateable) {
        this.wireUpScoreEvents()
        this.wireUpMoveEvents()
      }
    }.bind(this))
  },

  wireUpMoveEvents: function () {
    $(document).on('keydown', null, 'j', this.moveDown);
    $(document).on('keydown', null, 'k', this.moveUp);
    $(document).on('keydown', null, 'ctrl+n', this.moveDown);
    $(document).on('keydown', null, 'ctrl+p', this.moveUp);
  },

  moveDown: function () {
    var performance = this.state.selectedPerformance
    var index = this.state.performances.indexOf(performance)
    if (index < this.state.performances.length - 1) {
      this.setState({
        selectedPerformance: this.state.performances[index + 1]
      })
    }
  },

  moveUp: function () {
    var performance = this.state.selectedPerformance
    var index = this.state.performances.indexOf(performance)
    if (index > 0) {
      this.setState({
        selectedPerformance: this.state.performances[index - 1]
      })
    }
  },

  wireUpScoreEvents: function () {
    [0,1,2,3,4].forEach(function (num) {
      $(document).on('keydown', null, num.toString(), function (e) {
        var performance = this.state.selectedPerformance
        $.ajax({
          method: 'post',
          dataType: 'json',
          url: this.props.updatePerformancesPath,
          data: {
            performance: {
              objective_id: performance.id,
              score: num
            }
          },
          context: this,
        }).then(function (response) {
          performance.score = response.score
          this.setState({standards: this.state.standards})
        })
      }.bind(this))
    }, this)
  },

  performanceWasSelected: function (e, performance) {
    if (this.state.updateable) {
      this.setState({ selectedPerformance: performance })
    }
  },

  onSelectAll: function (e) {
    e.preventDefault()

    var performances = this.state.standards.reduce(function (result, standard) {
      standard.performances.forEach(function (performance) {
        result[performance.id] = performance
      })
      return result
    }, {})

    $.ajax({
      method: 'post',
      dataType: 'json',
      url: this.props.approveAllPath,
      data: {
        objective_ids: Object.keys(performances),
        score: 3
      },
      context: this,
    }).then(function (newPerformances) {
      newPerformances.forEach(function (newPerformance) {
        performances[newPerformance.id].score = newPerformance.score
      })
      this.setState({standards: this.state.standards})
    })
  },

  render: function () {
    var standardRows = this.state.standards.map(function (standard) {
      return <StudentStandardRow key={'standard-' + standard.id}
        standard={standard}
        selectedPerformance={this.state.selectedPerformance}
        performanceWasSelected={this.performanceWasSelected}
      >
      </StudentStandardRow>
    }, this)

    var table = <table className="table table-bordered table-striped">
      {standardRows}
    </table>

    var approveAll
    if (this.props.approveAllPath && this.state.updateable) {
      approveAll = <p key='approve-all' className="pull-right">
        <a href onClick={this.onSelectAll} className="btn btn-sm btn-primary">Approve All (3s)</a>
      </p>
    }

    return <div>
      {approveAll}
      {table}
    </div>
  }

})

var StudentStandardRow = React.createClass({
  render: function () {
    var performanceRows = this.props.standard.performances.map(function (performance) {
      return <PerformanceRow key={'performance-row-' + performance.id}
        selectedPerformance={this.props.selectedPerformance}
        performance={performance}
        performanceWasSelected={this.props.performanceWasSelected}
      />
    }, this)

    return <tbody>
      <tr className="tr-summary">
        <th>
          <a href={this.props.standard.standard_path}>{this.props.standard.name}</a>
        </th>
        <td></td>
      </tr>
      {performanceRows}
    </tbody>
  }
})

var PerformanceRow = React.createClass({
  performanceWasSelected: function (e) {
    this.props.performanceWasSelected(e, this.props.performance)
  },

  render: function () {
    var performance = this.props.performance
    var classNames = ['score-' + performance.score.toString()]

    if (this.props.selectedPerformance === performance) {
      classNames.push('score-selected')
    }
    return <tr>
      <td>
        <a href={performance.objective_path}>{performance.objective_name}</a>
      </td>
      <td onClick={this.performanceWasSelected} className={classNames.join(' ')}>
        {performance.score}
      </td>
    </tr>
  }
})
