var PerformanceTable = React.createClass({

  getInitialState: function () {
    return {
      tagFilter: null,
      standardFilter: null,
      loaded: false,
      selectedCell: {objectiveId: null, studentId: null, standardId: null},
      students: [],
      standards: [],
      indexedStandards: {},
      objectives: [],
      performances: [],
    }
  },

  getStandardsById: function (standards) {
    return standards.reduce(function (result, standard) {
      result[standard.id] = standard
      return result
    }, {})
  },

  getObjectivesInOrder: function (standards) {
    return standards.reduce(function (result, standard) {
      return result.concat(standard.objectives)
    }, [])
  },

  componentDidMount: function() {
    $.getJSON(this.props.performancesUrl).then(function (response) {
      response.loaded = true
      response.standardsById = this.getStandardsById(response.standards)
      response.objectives = this.getObjectivesInOrder(response.standards)
      response.selectedCell = {
        objectiveId: response.objectives[0].id,
        studentId: response.students[0].id,
        standardId: response.standards[0].id
      }
      this.setState(response)
    }.bind(this))

    $(document).on('keydown', null, 'h', this.moveLeft);
    $(document).on('keydown', null, 'l', this.moveRight);
    $(document).on('keydown', null, 'j', this.moveDown);
    $(document).on('keydown', null, 'k', this.moveUp);

    $(document).on('keydown', null, 'ctrl+b', this.moveLeft);
    $(document).on('keydown', null, 'ctrl+f', this.moveRight);
    $(document).on('keydown', null, 'ctrl+n', this.moveDown);
    $(document).on('keydown', null, 'ctrl+p', this.moveUp);

    [0,1,2,3,4].forEach(function (num) {
      $(document).on('keydown', null, num.toString(), function (e) {
        var studentUrl
        for (var i = 0; i < this.state.students.length; i++) {
          if (this.state.students[i].id === this.state.selectedCell.studentId) {
            studentUrl = this.state.students[i].performance_path
          }
        }
        $.ajax({
          method: 'post',
          dataType: 'json',
          url: studentUrl,
          data: {
            performance: {
              objective_id: this.state.selectedCell.objectiveId,
              score: num
            }
          }
        }).then(function (response) {
          this.state.performances[this.state.selectedCell.studentId] = this.state.performances[this.state.selectedCell.studentId] || {}
          this.state.performances[this.state.selectedCell.studentId][this.state.selectedCell.objectiveId] = response
          this.setState({performances: this.state.performances})
        }.bind(this))
      }.bind(this))
    }.bind(this))
  },

  getObjectiveById: function (id) {
    for (var i = 0; i < this.state.objectives.length; i++) {
      if (this.state.objectives[i].id === id) {
        return this.state.objectives[i]
      }
    }
  },

  moveLeft: function () {
    var studentIds = this.state.students.map(function (student) { return student.id })
    var index = studentIds.indexOf(this.state.selectedCell.studentId)
    if (index > 0) {
      index--
      this.setState({
        selectedCell: {
          objectiveId: this.state.selectedCell.objectiveId,
          standardId: this.state.selectedCell.standardId,
          studentId: studentIds[index]
        }
      })
    }
  },

  moveRight: function () {
    var studentIds = this.state.students.map(function (student) { return student.id })
    var index = studentIds.indexOf(this.state.selectedCell.studentId)
    if (index < studentIds.length - 1) {
      index++
      this.setState({
        selectedCell: {
          objectiveId: this.state.selectedCell.objectiveId,
          standardId: this.state.selectedCell.standardId,
          studentId: studentIds[index]
        }
      })
    }
  },

  moveDown: function () {
    var filteredStandards = this.getFilteredStandards()
    var objectiveIds = filteredStandards.reduce(function (result, standard) {
      return result.concat(standard.objectives.map(function(o){return o.id}))
    }, [])
    var index = objectiveIds.indexOf(this.state.selectedCell.objectiveId)
    if (index < objectiveIds.length - 1) {
      this.setState({
        selectedCell: {
          objectiveId: objectiveIds[index + 1],
          standardId: this.getObjectiveById(objectiveIds[index + 1]).standard_id,
          studentId: this.state.selectedCell.studentId
        }
      })
    }
  },

  moveUp: function () {
    var filteredStandards = this.getFilteredStandards()
    var objectiveIds = filteredStandards.reduce(function (result, standard) {
      return result.concat(standard.objectives.map(function(o){return o.id}))
    }, [])
    var index = objectiveIds.indexOf(this.state.selectedCell.objectiveId)
    if (index > 0) {
      this.setState({
        selectedCell: {
          objectiveId: objectiveIds[index - 1],
          standardId: this.getObjectiveById(objectiveIds[index - 1]).standard_id,
          studentId: this.state.selectedCell.studentId
        }
      })
    }
  },

  propTypes: {
    performancesUrl: React.PropTypes.string
  },

  selectedCellDidChange: function (e, selectedCell) {
    this.setState({ selectedCell: selectedCell })
  },

  tagWasClicked: function (e) {
    e.preventDefault()
    this.setState({
      tagFilter: e.target.innerHTML,
      standardFilter: null,
    })
    var filteredStandards = this.getFilteredStandards()
    this.setState({
      selectedCell: {
        standardId: filteredStandards[0].id,
        objectiveId: filteredStandards[0].objectives[0].id,
        studentId: this.state.students[0].id,
      }
    })
  },

  standardWasFiltered: function (e, standard) {
    e.preventDefault()
    this.setState({
      standardFilter: standard,
      tagFilter: null,
      selectedCell: {
        standardId: standard.id,
        objectiveId: standard.objectives[0].id,
        studentId: this.state.students[0].id,
      }
    })
  },

  clearFilters: function (e) {
    e.preventDefault()
    this.setState({
      standardFilter: null,
      tagFilter: null,
      selectedCell: {
        standardId: this.state.standards[0].id,
        objectiveId: this.state.standards[0].objectives[0].id,
        studentId: this.state.students[0].id,
      }
    })
  },

  getFilteredStandards: function () {
    if (this.state.standardFilter) {
      return [this.state.standardFilter]
    } else if (this.state.tagFilter) {
      return this.state.standards.filter(function (standard) {
        return standard.tags.map(function(tag){
          return tag.toLowerCase()
        }).indexOf(this.state.tagFilter.toLowerCase()) > -1
      }.bind(this))
    } else {
      return this.state.standards
    }
  },

  getObjectivesByStandard: function () {
    return this.state.objectives.reduce(function (result, objective) {
      result[objective.standard_id] = result[objective.standard_id] || []
      result[objective.standard_id].push(objective)
      return result
    }.bind(this), {})
  },

  render: function() {
    if (!this.state.loaded) {
      return <p>
        <img src={this.props.spinnerPath}/> Loading...
      </p>
    }

    var studentHeaders = this.state.students.map(function (student) {
      return <StudentHeader
        selectedCell={this.state.selectedCell}
        key={student.id}
        student={student}>
      </StudentHeader>
    }.bind(this))

    var filteredStandards = this.getFilteredStandards()

    var standardBodies = filteredStandards.map(function (standard) {
      return <StandardBody key={standard.id}
        standard={standard}
        students={this.state.students}
        performances={this.state.performances}
        selectedCell={this.state.selectedCell}
        selectedCellDidChange={this.selectedCellDidChange}
        tagWasClicked={this.tagWasClicked}
        standardWasFiltered={this.standardWasFiltered}
      >
      </StandardBody>
    }.bind(this))

    var clearFiltersLink
    if (this.state.tagFilter || this.state.standardFilter) {
      clearFiltersLink = <a className="hidden-print" href onClick={this.clearFilters}>Clear Filters</a>
    }

    return (
      <table className='table-performance-grid' onKeyUp={this.onKeyUp}>
        <thead>
          <tr>
            <th className="clear-filters">
              {clearFiltersLink}
            </th>
            {studentHeaders}
          </tr>
        </thead>
        {standardBodies}
      </table>
    );
  }
});

var StandardBody = React.createClass({

  shouldComponentUpdate: function (nextProps) {
    var iNowContainASelectedCell = this.props.selectedCell.standardId === this.props.standard.id
    var iWillContainASelectedCell = nextProps.selectedCell.standardId === this.props.standard.id
    return iNowContainASelectedCell || iWillContainASelectedCell
  },

  standardWasFiltered: function (e) {
    this.props.standardWasFiltered(e, this.props.standard)
  },

  render: function () {
    var studentCells = this.props.students.map(function (student) {
      return <td key={student.id + '_' + this.props.standard.id}>&nbsp;</td>
    }.bind(this))

    var objectiveRows = this.props.standard.objectives.map(function (objective) {
      return <ObjectiveRow key={objective.id}
        objective={objective}
        students={this.props.students}
        performances={this.props.performances}
        selectedCell={this.props.selectedCell}
        selectedCellDidChange={this.props.selectedCellDidChange}
        >
      </ObjectiveRow>
    }.bind(this))

    var tags = this.props.standard.tags.map(function (tag) {
      return <a href onClick={this.props.tagWasClicked} className="label label-info">{tag}</a>
    }.bind(this))

    return <tbody className="vertical-text">
      <tr className='tr-summary'>
        <th colSpan={this.props.students.length + 1}>
          <span className="standard-tags pull-right">{tags}</span>
          <span className="hidden-print">
            <a href={this.props.standard.edit_standard_path}>
              <i className="glyphicon glyphicon-pencil"></i>
            </a>
            &nbsp;
            <a href onClick={this.standardWasFiltered}>
              <i className="glyphicon glyphicon-filter"></i>
            </a>
            &nbsp;
          </span>
          <a href={this.props.standard.standard_path}>
            {this.props.standard.name}
          </a>
        </th>
      </tr>
      <tr className='tr-summary'>
        <th></th>
        {studentCells}
      </tr>
      {objectiveRows}
    </tbody>
  }

})

var ObjectiveRow = React.createClass({

  render: function () {
    var studentCells = this.props.students.map(function (student) {
      return <PerformanceCell
        key={['obj', student.id, this.props.objective.id].join('-')}
        student={student}
        performances={this.props.performances}
        objective={this.props.objective}
        selectedCell={this.props.selectedCell}
        selectedCellDidChange={this.props.selectedCellDidChange}
      >
      </PerformanceCell>
    }.bind(this))

    return <tr className='tr-objective'>
      <th>
        <span className="hidden-print">
          <a href={this.props.objective.edit_objective_path}>
            <i className="glyphicon glyphicon-pencil"></i>
          </a>
          &nbsp;
        </span>
        <a href={this.props.objective.objective_path}>
          {this.props.objective.name}
        </a>
      </th>
      {studentCells}
    </tr>
  }

})

var PerformanceCell = React.createClass({

  shouldComponentUpdate: function (nextProps) {
    var currentlySelected = this.props.objective.id === this.props.selectedCell.objectiveId &&
      this.props.student.id === this.props.selectedCell.studentId

    var willBeSelected = this.props.objective.id === nextProps.selectedCell.objectiveId &&
      this.props.student.id === nextProps.selectedCell.studentId

    return currentlySelected || willBeSelected
  },

  didClickCell: function (e) {
    var selectedCell = {
      studentId: this.props.student.id,
      objectiveId: this.props.objective.id,
      standardId: this.props.objective.standard_id
    }
    this.props.selectedCellDidChange(e, selectedCell)
  },

  render: function () {
    var student = this.props.student
    var objective = this.props.objective
    var selectedCell = this.props.selectedCell
    var studentPerformances = this.props.performances[student.id] || {}
    var performance = studentPerformances[objective.id] || {}
    var score = performance.score || 0
    var className = 'score-' + score

    var currentlySelected = this.props.objective.id === this.props.selectedCell.objectiveId &&
      this.props.student.id === this.props.selectedCell.studentId

    if(currentlySelected) {
      className += ' selected'
    }

    return <td onClick={this.didClickCell} className={className}>
      {score}
    </td>
  }
})

var StudentHeader = React.createClass({

  shouldComponentUpdate: function (nextProps) {
    return this.props.selectedCell.studentId === this.props.student.id ||
      nextProps.selectedCell.studentId === this.props.student.id
  },

  render: function () {
    var className = this.props.selectedCell.studentId === this.props.student.id ? 'selected' : null

    return <th className="vertical-text">
      <div>
        <span className={className}>
          <a href={this.props.student.performance_path}>
            {this.props.student.full_name}
          </a>
        </span>
      </div>
    </th>
  }

})
