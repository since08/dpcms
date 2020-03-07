require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:race) { FactoryGirl.create(:race, begin_date: Date.current) }
  describe 'seq_id 生成规则' do
    it 'seq_id的前缀应为开始日期' do
      race
      expect(race.seq_id.to_s.first(8)).to eq(race.begin_date.strftime('%Y%m%d'))
    end

    context '当前日期没有赛事时' do
      it '新建赛事，seq_id的尾数应为001' do
        seq_id = "#{race.begin_date.strftime('%Y%m%d')}001"
        expect(race.seq_id.to_s).to eq(seq_id)
      end

      context '当赛事日期改变成 20180202' do
        it 'seq_id 应变成 20180202001' do
          date = Date.new(2018,02,02)
          race.update(begin_date: date)
          seq_id = "#{date.strftime('%Y%m%d')}001"
          expect(race.seq_id.to_s).to eq(seq_id)
        end
      end
    end

    context '当赛事日期没有变化时' do
      it 'seq_id也不应有变化' do
        pre_seq_id = race.seq_id
        date = Date.new(2018,02,02)
        race.update(end_date: date)
        expect(race.seq_id).to eq(pre_seq_id)
      end
    end

    context '当前日期已存在多条赛事，且seq_id最大尾数为 010' do
      before do
        10.times {FactoryGirl.create(:race, begin_date: Date.current) }
      end

      it '新建赛事，seq_id的尾数应为011' do
        seq_id = "#{race.begin_date.strftime('%Y%m%d')}011"
        expect(race.seq_id.to_s).to eq(seq_id)
      end
    end
  end
end
