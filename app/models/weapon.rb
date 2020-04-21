class Weapon < ApplicationRecord
  has_many :actions
  has_many :damaging_users, through: :actions

  NAMES = {
    pistol: ['colt_mp', 'luger_mp', 'tt30_mp', 'webley_mp'],
    machinegun: ['thompson_mp', 'greasegun_mp', 'mp40_mp', 'ppsh_mp', 'pps42_mp', 'sten_mp', 'mp44_mp', 'SVT40_mp', 'bren_mp', 'greasegun_mp'],
    shotgun: ['shotgun_mp'],
    rifle: ['g43_mp', 'kar98k_mp', 'enfield_mp', 'm1carbine_mp', 'm1garand_mp', 'mosin_nagant_mp'],
    sniper: ['g43_sniper_mp', 'kar98k_sniper_mp', 'enfield_scope_mp', 'springfield_mp', 'mosin_nagant_sniper_mp'],
    stand_machinegun: ['30cal_stand_mp', 'mg42_bipod_stand_mp'],
    grenade: ['frag_grenade_german_mp', 'frag_grenade_american_mp', 'frag_grenade_russian_mp', 'frag_grenade_british_mp'],
    launcher: ['panzerschreck_mp']
  }
  enum weapon_type: [:pistol, :machinegun, :shotgun, :rifle, :sniper, :stand_machinegun, :grenade, :launcher, :unknown]

end