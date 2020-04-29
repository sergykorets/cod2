class UsersController < ApplicationController

  def info
    user = User.find_by(id: params[:id])
    @info = {
        name: user.name,
        avatar: user.avatar.url,
        average_damage: user.stats['average_damage'],
        favorite_body_target: user.stats['favorite_body_target'],
        favorite_weapon: user.stats['favorite_weapon'],
        average_suicides_per_round: user.stats['average_suicides_per_round'],
        average_self_damage_per_round: user.stats['average_self_damage_per_round'],
        headshots: user.stats['headshots'],
        grenades: user.stats['grenades'],
        team_damage_per_round: user.stats['team_damage_per_round'],
        average_kills_per_round: user.stats['average_kills_per_minute'],
        kill_death_rate: user.stats['kill_death_rate'],
        rounds: "%02d:%02d:%02d:%02d" % [user.stats['total_in_game']/86400, user.stats['total_in_game']/3600%24, user.stats['total_in_game']/60%60, user.stats['total_in_game']%60],
        rating: user.rating,
        favorite_body_targets: user.favorite_body_targets.sort.to_h,
        nicknames: user.nicknames.pluck(:name)
    }
  end
end