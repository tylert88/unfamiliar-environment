var LearningExperienceAssignmentTable = React.createClass({

  getInitialState: function () {
    return {
      currentCohortId: null,
      cohorts: [],
      learning_experiences: []
    }
  },

  componentDidMount: function () {
    $.getJSON(this.props.dataUrl).then(function (data) {
      this.setState(data);
    }.bind(this))
  },

  cohortWasChanged: function (e) {
    if (e.target.value) {
      this.setState({currentCohortId: parseInt(e.target.value, 10)});
    } else {
      this.setState({currentCohortId: null});
    }
  },

  assignCohort: function (experience) {
    $.post(experience.assignmentUrl, {assign: this.state.currentCohortId}).then(function () {
      experience.assignedCohortIds.push(this.state.currentCohortId);
      this.setState({learning_experiences: this.state.learning_experiences});
    }.bind(this))
  },

  unassignCohort: function (experience) {
    $.post(experience.assignmentUrl, {unassign: this.state.currentCohortId}).then(function () {
      var index = experience.assignedCohortIds.indexOf(this.state.currentCohortId);
      experience.assignedCohortIds.splice(index, 1);
      this.setState({learning_experiences: this.state.learning_experiences});
    }.bind(this))
  },

  render: function () {
    var trs = this.state.learning_experiences.map(function (experience) {
      var button;
      if (!this.state.currentCohortId) {
        button = <small>Select a cohort above...</small>
      } else if (experience.assignedCohortIds.indexOf(this.state.currentCohortId) > -1) {
        button = <button className="btn btn-warning btn-xs" onClick={this.unassignCohort.bind(this, experience)}>Unassign</button>
      } else {
        button = <button className="btn btn-primary btn-xs" onClick={this.assignCohort.bind(this, experience)}>Assign</button>
      }

      return <tr>
        <td>{experience.name}</td>
        <td className="text-right">
          {button}
        </td>
      </tr>
    }, this);

    var table = <table className="table table-striped table-compact table-bordered table-hover">
      <thead>
        <tr>
          <td>Learning Experience</td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        {trs}
      </tbody>
    </table>

    var options = this.state.cohorts.map(function (cohort) {
      return <option value={cohort.id}>{cohort.name}</option>
    })

    return <div>
      <div className="row">
        <div className="col-md-4">
          <p>
            <select value={this.state.currentCohortId} className="form-control" onChange={this.cohortWasChanged}>
              <option>Choose a cohort...</option>
              {options}
            </select>
          </p>
        </div>
      </div>
      {table}
    </div>
  }

})
