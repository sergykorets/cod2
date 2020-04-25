class PagesController < ApplicationController

  def index
    @users = User.where.not(role: :admin).map do |user|
      { id: user.id,
        name: user.name,
        average_damage: user.average_damage,
        favorite_body_target: user.favorite_body_target,
        favorite_weapon: user.favorite_weapon,
        rounds: user.rounds.count,
        average_suicides_per_round: user.average_suicides_per_round,
        average_self_damage_per_round: user.average_self_damage_per_round,
        headshots: user.headshots,
        grenades: user.grenades,
        team_damage_per_round: user.team_damage_per_round,
        average_kills_per_round: user.average_kills_per_round,
        kill_death_rate: user.kill_death_rate,
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