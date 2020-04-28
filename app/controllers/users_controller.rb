class UsersController < ApplicationController

  def info
    user = User.find_by(id: params[:id])
    @info = {
        name: user.name,
        avatar: user.avatar.url,
        average_damage: user.average_damage,
        favorite_body_target: user.favorite_body_target,
        favorite_weapon: user.favorite_weapon,
        headshots: user.headshots,
        rounds: Time.at(user.total_in_game).utc.strftime("%H:%M:%S"),
        average_kills_per_round: user.average_kills_per_minute,
        kill_death_rate: user.kill_death_rate,
        average_suicides_per_round: user.average_suicides_per_round,
        average_self_damage_per_round: user.average_self_damage_per_round,
        grenades: user.grenades,
        team_damage_per_round: user.team_damage_per_round,
        rating: user.rating,
        favorite_body_targets: user.favorite_body_targets.sort.to_h,
        nicknames: user.nicknames.pluck(:name)

    }
  end
end