import React, {Fragment} from 'react';
import {NotificationContainer, NotificationManager} from 'react-notifications';


export default class UserInfo extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      user: this.props.info,
      loading: true
    };
  }

  componentDidMount() {
    this.setState({loading: false})
  }

  totalHits = () => {
    return Object.values(this.state.user.favorite_body_targets).reduce((a, b) => a + b, 0)
  };

  render() {
    console.log(this.state)
    return (
      <Fragment>
        <NotificationContainer/>
        {!this.state.loading &&
          <Fragment>
            <section id="services" className="services page">
              <div className="container wow fadeInUp">
                <div className="row">
                  <div className="col-12">
                    <div className="rela-block container">
                      <div className="rela-block profile-card">
                        <div className="profile-pic" id="profile_pic" style={{backgroundImage: `url(${this.state.user.avatar})`}}/>
                        <div className="rela-block profile-name-container">
                          <div className="rela-block user-name" id="user_name">{this.state.user.name}</div>
                          <div className="rela-block user-desc" id="user_description">Рейтинг: ({this.state.user.rating})</div>
                        </div>
                        <div className="rela-block profile-card-stats">
                          <div className="floated profile-stat average_damage">{this.state.user.average_damage}<br/></div>
                          <div className="floated profile-stat favorite_body_target">{this.state.user.favorite_body_target}<br/></div>
                          <div className="floated profile-stat favorite_weapon">{this.state.user.favorite_weapon}<br/></div>
                          <div className="floated profile-stat headshots">{this.state.user.headshots} %<br/></div>
                        </div>
                        <div className="rela-block profile-card-stats">
                          <div className="floated profile-stat rounds">{this.state.user.rounds}<br/></div>
                          <div className="floated profile-stat average_kills_per_round">{this.state.user.average_kills_per_round}<br/></div>
                          <div className="floated profile-stat kill_death_rate">{this.state.user.kill_death_rate} %<br/></div>
                          <div className="floated profile-stat average_suicides_per_round">{this.state.user.average_suicides_per_round} %<br/></div>
                        </div>
                        <div className="rela-block profile-card-stats">
                          <div className="floated profile-stat average_self_damage_per_round">{this.state.user.average_self_damage_per_round}<br/></div>
                          <div className="floated profile-stat grenades">{this.state.user.grenades}<br/></div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </section>
            <section className='services page text-center'>
              <h1 className="mb-2">Попадання</h1>
              <h5 className="mb-2">Всього попадань: {this.totalHits()}</h5>
              <h6 className="mb-4">Удар прикладом: {(this.state.user.favorite_body_targets.melee * 100 / this.totalHits()).toFixed(2)}%</h6>
              <div className='human-body text-center'>
                {Object.keys(this.state.user.favorite_body_targets).filter(item => item !== 'melee').map((target, i) => {
                  return (
                    <span key={i} className={`body-parts ${target}`}>{(this.state.user.favorite_body_targets[target] * 100 / this.totalHits()).toFixed(2)}%</span>
                  )
                })}
              </div>
            </section>
        </Fragment>}
      </Fragment>
    );
  }
}
