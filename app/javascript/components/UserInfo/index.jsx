import React, {Fragment} from 'react';
import { Modal, ModalHeader, FormGroup, Label, Input, ButtonToggle } from 'reactstrap';
import {NotificationContainer, NotificationManager} from 'react-notifications';
import ReactGA from 'react-ga';
import Masonry from 'react-masonry-css';

export default class UserInfo extends React.Component {
  constructor(props) {
    super(props);

    this.state = {

    };
  }

  componentDidMount() {
    if (!this.props.admin) {
      ReactGA.initialize('UA-116820611-4');
      ReactGA.ga('send', 'pageview', `/racer/${this.props.info.name}`);
    }
  }

  handleClick = (url) => {
    window.location = url;
  };

  render() {
    const user = this.props.info;
    return (
      <Fragment>
        <NotificationContainer/>
        <section id="services" className="services page">
          <div className="container wow fadeInUp">
            <div className="row">
              <div className="col-12">
                <div className="rela-block container">
                  <div className="rela-block profile-card">
                    <div className="profile-pic" id="profile_pic" style={{backgroundImage: `url(${user.avatar})`}}/>
                    <div className="rela-block profile-name-container">
                      <div className="rela-block user-name" id="user_name">{user.name}</div>
                      <div className="rela-block user-desc" id="user_description">Рейтинг: ({user.rating})</div>
                    </div>
                    <div className="rela-block profile-card-stats">
                      <div className="floated profile-stat average_damage">{user.average_damage}<br/></div>
                      <div className="floated profile-stat favorite_body_target">{user.favorite_body_target}<br/></div>
                      <div className="floated profile-stat favorite_weapon">{user.favorite_weapon}<br/></div>
                      <div className="floated profile-stat headshots">{user.headshots} %<br/></div>
                    </div>
                    <div className="rela-block profile-card-stats">
                      <div className="floated profile-stat rounds">{user.rounds}<br/></div>
                      <div className="floated profile-stat average_kills_per_round">{user.average_kills_per_round}<br/></div>
                      <div className="floated profile-stat kill_death_rate">{user.kill_death_rate} %<br/></div>
                      <div className="floated profile-stat average_suicides_per_round">{user.average_suicides_per_round} %<br/></div>
                    </div>
                    <div className="rela-block profile-card-stats">
                      <div className="floated profile-stat average_self_damage_per_round">{user.average_self_damage_per_round}<br/></div>
                      <div className="floated profile-stat grenades">{user.grenades}<br/></div>
                    </div>
                  </div>
                  <div className="rela-block content">

                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </Fragment>
    );
  }
}
