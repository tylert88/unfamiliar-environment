var SubjectForm = React.createClass({
  getInitialState: function () {
    return {
      learningExperiences: window.learning_experiences
    }
  },

  toggleLearningExperience: function (e, learningExperience) {
    e.preventDefault()
    this.forceUpdate()
    learningExperience.selected = !learningExperience.selected
  },

  render: function () {
    return <div>
      <SubjectLearningExperiencesTable
        learningExperiences={this.state.learningExperiences}
        toggleLearningExperience={this.toggleLearningExperience}
        />
    </div>
  }

})

var SubjectLearningExperiencesTable = React.createClass({
  render: function () {
    var self = this;
    var selectedLearningExperiences = [];
    var unselectedLearningExperiences = [];

    this.props.learningExperiences.forEach(function(learningExperience) {
      var row = <SubjectLearningExperienceRow key={'le-' + learningExperience.id}
        learningExperience={learningExperience}
        toggleLearningExperience={self.props.toggleLearningExperience}
        />

      if (!learningExperience.selected) {
        unselectedLearningExperiences.push(row);
      } else {
        selectedLearningExperiences.push(row);
      }
    })

    return (
      <div>
        <LearningExperienceTable tableType='Selected'>{ selectedLearningExperiences }</LearningExperienceTable>
        <LearningExperienceTable tableType='Inactive'>{ unselectedLearningExperiences }</LearningExperienceTable>
      </div>
    )
  }
})

var LearningExperienceTable = React.createClass({
  render: function() {
    if (this.props.children.length) {
      return (
        <div className="form-group">
          <table className="table table-striped table-compact table-bordered">
            <tbody>
              <tr className="tr-summary">
                <th>{ this.props.tableType } Learning Experiences</th>
                <th></th>
              </tr>
              { this.props.children }
            </tbody>
          </table>
        </div>
      )
    } else {
      return <div></div>
    }
  }
})

var SubjectLearningExperienceRow = React.createClass({
  toggle: function (e) {
    this.props.toggleLearningExperience(e, this.props.learningExperience)
  },

  render: function () {
    var objectiveButton
    if (this.props.learningExperience.selected) {
      learningExperienceButton = <div>
        <a onClick={this.toggle} className="btn btn-warning btn-sm btn-block">Remove</a>
        <input type="hidden" name="subject[learning_experience_ids][]" value={this.props.learningExperience.id} />
      </div>
    } else {
      learningExperienceButton = <a onClick={this.toggle} className="btn btn-primary btn-sm btn-block">Add</a>
    }

    return <tr>
      <td><a target="_blank" href={this.props.learningExperience.learning_experience_path}>{this.props.learningExperience.name}</a></td>
      <td>{learningExperienceButton}</td>
    </tr>
  }
})
