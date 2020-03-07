require 'rails_helper'

RSpec.describe RaceRank, type: :model do
  let(:race) { FactoryGirl.create(:race, begin_date: Date.current) }
  let(:second_race) { FactoryGirl.create(:race, begin_date: Date.current) }
  let(:player) { FactoryGirl.create(:player, dpi_total_earning: 0, dpi_total_score: 0) }
  let(:n_player) { FactoryGirl.create(:player, dpi_total_earning: 0, dpi_total_score: 0) }
  let(:race_rank) { RaceRank.create(race: race, player: player, earning: 1000, score: 10, ranking: 1) }

  describe '创建排名成功' do
    it '应为选择的牌手增加相应的earning与score' do
      expect(player.dpi_total_earning).to eq(0)
      expect(player.dpi_total_score).to eq(0)

      RaceRank.create(race: race, player: player, earning: 1000, score: 10, ranking: 1)
      player.reload
      expect(player.dpi_total_earning).to eq(1000)
      expect(player.dpi_total_score).to eq(10)

      RaceRank.create(race: second_race, player: player, earning: 1000, ranking: 2)
      player.reload
      expect(player.dpi_total_earning).to eq(2000)
      expect(player.dpi_total_score).to eq(10)
    end
  end

  describe '删除排名成功' do
    it '应为选择的牌手减去相应的earning与score' do
      race_rank
      player.reload
      expect(player.dpi_total_earning).to eq(1000)
      expect(player.dpi_total_score).to eq(10)
      race_rank.destroy
      player.reload
      expect(player.dpi_total_earning).to eq(0)
      expect(player.dpi_total_score).to eq(0)
    end
  end

  describe '更新排名成功' do
    it '没有更新牌手id，修改相应的差值' do
      race_rank
      player.reload
      expect(player.dpi_total_earning).to eq(1000)
      expect(player.dpi_total_score).to eq(10)
      race_rank.update(earning: '2000', score: '20')
      player.reload
      expect(player.dpi_total_earning).to eq(2000)
      expect(player.dpi_total_score).to eq(20)

      race_rank.update(earning: '500', score: '5')
      player.reload
      expect(player.dpi_total_earning).to eq(500)
      expect(player.dpi_total_score).to eq(5)
    end

    it '更新牌手id，减去old_player相应的值，增加new_player相应的值' do
      race_rank
      player.reload
      expect(player.dpi_total_earning).to eq(1000)
      expect(player.dpi_total_score).to eq(10)
      expect(n_player.dpi_total_earning).to eq(0)
      expect(n_player.dpi_total_score).to eq(0)

      race_rank.update(player: n_player)
      player.reload
      expect(player.dpi_total_earning).to eq(0)
      expect(player.dpi_total_score).to eq(0)
      n_player.reload
      expect(n_player.dpi_total_earning).to eq(1000)
      expect(n_player.dpi_total_score).to eq(10)

      race_rank.update(player: player, earning: '500', score: '5')
      player.reload
      expect(player.dpi_total_earning).to eq(500)
      expect(player.dpi_total_score).to eq(5)
      n_player.reload
      expect(n_player.dpi_total_earning).to eq(0)
      expect(n_player.dpi_total_score).to eq(0)
    end
  end
end
