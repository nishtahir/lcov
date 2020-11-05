module Lcov
  VERSION = "0.1.0"

  def self.parse(content : String) : Report
    records = [] of Record
    rec = Record.new
    content.each_line do |line|
      line = line.strip
      unless line.empty?
        temp = line.split(':')
        isr = temp[0]
        data = temp[1]? || ""

        case isr
        when "TN"
          rec.name = data
        when "SF"
          rec.file = data
        when "FN"
          hits, name = data.split(',')
          rec.fn_ln[name] = hits.to_u32
        when "FNF"
          rec.fn_found = data.to_u32
        when "FNH"
          rec.fn_hit = data.to_u32
        when "BRF"
          rec.br_found = data.to_u32
        when "BRH"
          rec.br_hit = data.to_u32
        when "LF"
          rec.ln_found = data.to_u32
        when "LH"
          rec.ln_hit = data.to_u32
        when "DA"
          line_num, hits = data.split(',').map { |x| x.to_u32 }
          rec.ln_data[line_num] = hits.to_u32
        when "BRDA"
          line_num, blk, br, hit = data.split(',').map { |x| x.to_u32 }
          rec.br_data.push(BrData.new(line_num, blk, br, hit))
        when "FNDA"
          hits, name = data.split(',')
          rec.fn_data[name] = hits.to_u32
        when "end_of_record"
          records.push(rec)
          rec = Record.new
        else
        end
      end
    end
    Report.new(records)
  end

  class Report
    getter records : Array(Record)

    def initialize(@records)
    end

    def to_s(io)
      io << records.join("\n")
    end
  end

  class Record
    property name : String
    property file : String
    property fn_found : UInt32
    property fn_hit : UInt32
    property fn_ln : Hash(String, UInt32)
    property fn_data : Hash(String, UInt32)
    property br_hit : UInt32
    property br_found : UInt32
    property br_data : Array(BrData)
    property ln_hit : UInt32
    property ln_found : UInt32
    property ln_data : Hash(UInt32, UInt32)

    def initialize(
      @name = "",
      @file = "",
      @fn_found = 0_u32,
      @fn_hit = 0_u32,
      @fn_ln = {} of String => UInt32,
      @fn_data = {} of String => UInt32,
      @br_hit = 0_u32,
      @br_found = 0_u32,
      @br_data = [] of BrData,
      @ln_hit = 0_u32,
      @ln_found = 0_u32,
      @ln_data = {} of UInt32 => UInt32
    )
    end

    def to_s(io)
      io << "TN:#{name}\n"
      io << "SF:#{file}\n"
      io << "#{fn_ln.join("\n") { |k, v| "FN:#{k},#{v}" }}\n" unless fn_ln.empty?
      io << "FNF:#{fn_found}\n"
      io << "FNH:#{fn_hit}\n"
      io << "#{fn_data.join("\n") { |k, v| "FNDA:#{k},#{v}" }}\n" unless fn_data.empty?
      io << "#{ln_data.join("\n") { |k, v| "DA:#{k},#{v}" }}\n" unless ln_data.empty?
      io << "LF:#{ln_found}\n"
      io << "LH:#{ln_hit}\n"
      io << "#{br_data.join("\n")}\n" unless br_data.empty?
      io << "BRF:#{br_found}\n"
      io << "BRH:#{br_hit}\n"
      io << "end_of_record"
    end
  end

  class BrData
    property line : Int::Unsigned
    property blk : Int::Unsigned
    property br : Int::Unsigned
    property hit : Int::Unsigned

    def initialize(
      @line,
      @blk = 0_u32,
      @br = 0_u32,
      @hit = 0_u32
    )
    end

    def to_s(io)
      io << "BRDA:#{line},#{blk},#{br},#{hit}"
    end
  end
end
