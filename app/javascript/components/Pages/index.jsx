import React, {Fragment} from 'react';
import { Modal, ModalHeader, FormGroup, Label, Input, ButtonToggle } from 'reactstrap';
import {NotificationContainer, NotificationManager} from 'react-notifications';

export default class Home extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      style: { transform: 'translateY(0px)' },
      users: this.props.users.sort((a,b) => b.rating - a.rating),
      sort: {
        field: '',
        descending: true
      },
    };
  }

  componentDidMount() {
    window.addEventListener('scroll', this.handleScroll);
  }

  componentWillUnmount() {
    window.removeEventListener('scroll', this.handleScroll);
  }

  handleScroll = () => {
    const $navbar = $('.navbar');
    const tableOffset = $('.dark').offset().top;
    let navOffset = $navbar.offset().top, distance = (tableOffset - navOffset);
    let itemTranslate = navOffset - tableOffset + $navbar.height();
    if (distance < $navbar.height()) {
      this.setState({...this.state,
        style: { transform: `translateY(${itemTranslate}px)` }
      });
    } else {
      this.setState({...this.state,
        style: { transform: `translateY(0px)` }
      });
    }
  };

  onSort = (field) => {
    const descending = this.state.sort.field === field ? !this.state.sort.descending : this.state.sort.descending
    let users = this.state.users;
    //users.sort((a,b) => a[field] - b[field])
    this.setState({
      ...this.state,
      users: users.sort((a,b) => descending ? a[field] - b[field] : b[field] - a[field]),
      sort: {
        field: field,
        descending: descending
      }
    });
    // $.ajax({
    //   url: '/home.json',
    //   type: 'GET',
    //   data: {
    //     sort: field,
    //     descending: descending
    //   },
    //   success: (resp) => {
    //     this.setState({
    //       ...this.state,
    //       users: resp.users,
    //       sort: {
    //         field: field,
    //         descending: descending
    //       }
    //     });
    //   }
    // });
  };

  render() {
    return (
      <Fragment>
        <NotificationContainer/>
        <section id="services" className="services page">
          <table className='dark' style={{marginTop: 20 + 'px'}}>
            <thead style={this.state.style}>
            <tr>
              <th><h1>Ім'я</h1></th>
              <th onClick={() => this.onSort('average_damage')}><h1>Урон</h1></th>
              <th><h1>Попадання</h1></th>
              <th><h1>Зброя</h1></th>
              <th onClick={() => this.onSort('headshots')}><h1>Хеди</h1></th>
              <th onClick={() => this.onSort('average_kills_per_round')}><h1>Вбивств/раунд</h1></th>
              <th onClick={() => this.onSort('kill_death_rate')}><h1>Вбивств/смертей</h1></th>
              <th onClick={() => this.onSort('average_suicides_per_round')}><h1>Суіцид</h1></th>
              <th onClick={() => this.onSort('average_self_damage_per_round')}><h1>Самоурон</h1></th>
              <th onClick={() => this.onSort('team_damage_per_round')}><h1>Урон напарників</h1></th>
              <th onClick={() => this.onSort('grenades')}><h1>Урон гранатою</h1></th>
              <th onClick={() => this.onSort('rounds')}><h1>Раунди</h1></th>
              <th onClick={() => this.onSort('rating')}><h1>Рейтинг</h1></th>
            </tr>
            </thead>
            <tbody>
            { this.state.users.map((u, index) => {
              return (
                <tr key={index}>
                  <td><a href={`/player/${u.id}`}>{u.name}</a></td>
                  <td>{u.average_damage}</td>
                  <td>{u.favorite_body_target}</td>
                  <td>{u.favorite_weapon}</td>
                  <td>{u.headshots} %</td>
                  <td>{u.average_kills_per_round}</td>
                  <td>{u.kill_death_rate} %</td>
                  <td>{u.average_suicides_per_round} %</td>
                  <td>{u.average_self_damage_per_round}</td>
                  <td>{u.team_damage_per_round}</td>
                  <td>{u.grenades}</td>
                  <td>{u.rounds}</td>
                  <td>{u.rating}</td>
                </tr>
              )
            })}
            </tbody>
          </table>
        </section>
      </Fragment>
    );
  }
}
