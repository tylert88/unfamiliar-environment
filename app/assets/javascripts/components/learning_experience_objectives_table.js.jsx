var LearningExperienceForm = React.createClass({

  getInitialState: function () {
    return {
      standards: window.standards
    }
  },

  objectiveAdded: function (e, objective) {
    e.preventDefault()
    objective.selected = true
    this.setState({standards: this.state.standards})
  },

  objectiveRemoved: function (e, objective) {
    e.preventDefault()
    objective.selected = false
    this.setState({standards: this.state.standards})
  },

  render: function () {
    return <div>
      <LearningExperienceSelectedObjectives key="selected-objectives"
        standards={this.state.standards}
        objectiveRemoved={this.objectiveRemoved}
        objectiveAdded={this.objectiveAdded}
        />
      <LearningExperienceStandardsTable key="standards"
        standards={this.state.standards}
        objectiveRemoved={this.objectiveRemoved}
        objectiveAdded={this.objectiveAdded}
        />
    </div>
  }

})

var LearningExperienceSelectedObjectives = React.createClass({

  render: function () {
    var objectives = this.props.standards.reduce(function (results, standard) {
      return results.concat(standard.objectives.filter(function (objective) {
        return objective.selected
      }))
    }, [])

    if (objectives.length) {
      var objectiveRows = objectives.map(function (objective) {
        return <LearningExperienceObjectiveRow key={'selected-obj-' + objective.id}
          objective={objective}
          objectiveRemoved={this.props.objectiveRemoved}
          objectiveAdded={this.props.objectiveAdded}
          />
      }, this)

      return <div className="form-group">
        <table className="table table-striped table-compact table-bordered">
          <tbody>
            <tr className="tr-summary">
              <th>Selected Objectives</th>
              <th></th>
            </tr>
            {objectiveRows}
          </tbody>
        </table>
      </div>
    } else {
      return <div></div>
    }
  }
})

var LearningExperienceStandardsTable = React.createClass({

  render: function () {
    var standardRows = []
    this.props.standards.forEach(function (standard) {
      var filtered = standard.objectives.filter(function (objective) {
        return !objective.selected
      })

      if (filtered.length) {
        var objectiveRows = filtered.map(function (objective) {
          return <LearningExperienceObjectiveRow key={'unselected-' + objective.id}
            objective={objective}
            objectiveRemoved={this.props.objectiveRemoved}
            objectiveAdded={this.props.objectiveAdded}
           />
        }, this)
        standardRows.push(<tbody key={standard.id}>
          <tr className="tr-summary">
            <th><a target="_blank" href={standard.standard_path}>{standard.name}</a></th>
            <td></td>
          </tr>
          {objectiveRows}
        </tbody>)
      }
    }, this)

    return <div className="form-group">
      <table className="table table-bordered table-striped table-compact">
        {standardRows}
      </table>
    </div>
  }

})

var LearningExperienceObjectiveRow = React.createClass({
  add: function (e) {
    this.props.objectiveAdded(e, this.props.objective)
  },

  remove: function (e) {
    this.props.objectiveRemoved(e, this.props.objective)
  },

  render: function () {
    var objectiveButton
    if (this.props.objective.selected) {
      objectiveButton = <div>
        <a onClick={this.remove} className="btn btn-warning btn-sm btn-block">Remove</a>
        <input type="hidden" name="learning_experience[objective_ids][]" value={this.props.objective.id} />
      </div>
    } else {
      objectiveButton = <a onClick={this.add} className="btn btn-primary btn-sm btn-block">Add</a>
    }

    return <tr>
      <td><a target="_blank" href={this.props.objective.objective_path}>{this.props.objective.name}</a></td>
      <td>{objectiveButton}</td>
    </tr>
  }
})
