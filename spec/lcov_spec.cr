require "./spec_helper"

describe Lcov do
  file = File.read("spec/test.info")
  report = Lcov.parse(file)
  describe "parse" do
    it "should contain 2 records" do
      report.records.size.should eq(2)
    end

    it "should parse titles correctly" do
      report.records[0].name.should eq("Test 1")
      report.records[1].name.should eq("")
    end
    it "should parse test files correctly" do
      report.records[0].file.should eq("test.cr")
      report.records[1].file.should eq("")
    end
    it "should parse functions found correctly" do
      report.records[0].fn_found.should eq(2)
      report.records[1].fn_found.should eq(1)
    end
    it "should parse functions hit correctly" do
      report.records[0].fn_hit.should eq(2)
      report.records[1].fn_hit.should eq(1)
    end
    it "should parse function lines correctly" do
      first = report.records[0].fn_ln
      first.size.should eq(2)
      first["mount"].should eq(13)
      first["(anonymous_2)"].should eq(19)

      second = report.records[1].fn_ln
      second.size.should eq(1)
      second["create"].should eq(4)
    end
    it "should parse branches found correctly" do
      report.records[0].br_found.should eq(0)
      report.records[1].br_found.should eq(10)
    end
    it "should parse branches hit correctly" do
      report.records[0].br_hit.should eq(0)
      report.records[1].br_hit.should eq(10)
    end
    it "should parse branch data correctly" do
      first = report.records[0].br_data
      first.size.should eq(0)

      second = report.records[1].br_data
      second.size.should eq(10)

      data = second[0]
      data.line.should eq(4)
      data.blk.should eq(1)
      data.br.should eq(0)
      data.hit.should eq(32)
    end
    it "should parse lines found correctly" do
      report.records[0].ln_found.should eq(12)
      report.records[1].ln_found.should eq(18)
    end
    it "should parse lines hit correctly" do
      report.records[0].ln_hit.should eq(12)
      report.records[1].ln_hit.should eq(18)
    end
    it "should parse line data correctly" do
      first = report.records[0].ln_data
      first.size.should eq(12)
      first[0].should eq(1)
      first[10].should eq(9)
      first[11].should eq(1)
      first[13].should eq(1)
      first[14].should eq(1)
      first[15].should eq(1)
      first[16].should eq(1)
      first[17].should eq(1)
      first[18].should eq(1)
      first[19].should eq(1)
      first[20].should eq(1)
      first[21].should eq(1)

      second = report.records[1].ln_data
      second.size.should eq(18)
      second[0].should eq(90)
      second[4].should eq(1)
      second[5].should eq(90)
      second[32].should eq(10)
    end
  end
  describe "BrData" do
    it "should correctly format data when to_s is called" do
      data = Lcov::BrData.new(4_u32, 1_u32, 0_u32, 32_u32)
      data.to_s.should eq("BRDA:4,1,0,32")
    end
  end
  describe "Report" do
    it "should correctly format data when to_s is called" do
      report.to_s.should eq(
        "TN:Test 1\n" \
        "SF:test.cr\n" \
        "FN:mount,13\n" \
        "FN:(anonymous_2),19\n" \
        "FNF:2\n" \
        "FNH:2\n" \
        "FNDA:mount,1\n" \
        "FNDA:(anonymous_2),1\n" \
        "DA:0,1\n" \
        "DA:10,9\n" \
        "DA:11,1\n" \
        "DA:13,1\n" \
        "DA:14,1\n" \
        "DA:15,1\n" \
        "DA:16,1\n" \
        "DA:17,1\n" \
        "DA:18,1\n" \
        "DA:19,1\n" \
        "DA:20,1\n" \
        "DA:21,1\n" \
        "LF:12\n" \
        "LH:12\n" \
        "BRF:0\n" \
        "BRH:0\n" \
        "end_of_record\n" \
        "TN:\n" \
        "SF:\n" \
        "FN:create,4\n" \
        "FNF:1\n" \
        "FNH:1\n" \
        "FNDA:create,90\n" \
        "DA:0,90\n" \
        "DA:4,1\n" \
        "DA:5,90\n" \
        "DA:6,25\n" \
        "DA:9,65\n" \
        "DA:11,55\n" \
        "DA:14,55\n" \
        "DA:18,55\n" \
        "DA:19,55\n" \
        "DA:20,47\n" \
        "DA:21,47\n" \
        "DA:23,55\n" \
        "DA:26,10\n" \
        "DA:27,10\n" \
        "DA:28,2\n" \
        "DA:30,10\n" \
        "DA:31,10\n" \
        "DA:32,10\n" \
        "LF:18\n" \
        "LH:18\n" \
        "BRDA:4,1,0,32\n" \
        "BRDA:4,1,1,58\n" \
        "BRDA:4,2,0,32\n" \
        "BRDA:4,2,1,58\n" \
        "BRDA:5,3,0,25\n" \
        "BRDA:5,3,1,65\n" \
        "BRDA:9,4,0,55\n" \
        "BRDA:9,4,1,10\n" \
        "BRDA:27,5,0,2\n" \
        "BRDA:27,5,1,8\n" \
        "BRF:10\n" \
        "BRH:10\n" \
        "end_of_record"
      )
    end
  end
end
