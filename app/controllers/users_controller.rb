class UsersController < ApplicationController

  def info
    @admin = current_user&.admin?
    user = User.find_by(id: params[:id])
    @info = {
        name: user.name,
        avatar: user.avatar.url,
        average_damage: user.average_damage,
        favorite_body_target: user.favorite_body_target,
        favorite_weapon: user.favorite_weapon,
        headshots: user.headshots,
        rounds: user.rounds.count,
        average_kills_per_round: user.average_kills_per_round,
        kill_death_rate: user.kill_death_rate,
        average_suicides_per_round: user.average_suicides_per_round,
        average_self_damage_per_round: user.average_self_damage_per_round,
        grenades: user.grenades,
        rating: user.rating,

    }
  end
end