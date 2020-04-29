class PagesController < ApplicationController

  def index
    @users = User.where.not(role: :admin).map do |user|
      { id: user.id,
        name: user.name,
        average_damage: user.stats['average_damage'],
        favorite_body_target: user.stats['favorite_body_target'],
        favorite_weapon: user.stats['favorite_weapon'],
        rounds: user.stats['total_in_game'],
        average_suicides_per_round: user.stats['average_suicides_per_round'],
        average_self_damage_per_round: user.stats['average_self_damage_per_round'],
        headshots: user.stats['headshots'],
        grenades: user.stats['grenades'],
        team_damage_per_round: user.stats['team_damage_per_round'],
        average_kills_per_round: user.stats['average_kills_per_minute'],
        kill_death_rate: user.stats['kill_death_rate'],
        rating: user.rating.round(2)
      }
    end
    respond_to do |format|
      format.html { render :index }
      format.json {{success: true, users: @users}}
    end
  end

  def refresh_statistics
    ParseService.start
    redirect_to root_path
  end
end