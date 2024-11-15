package com.nomus.m2m.pojo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "datausage")
public class DataUsage {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column
	private int id;
	@Column
	private String s1daydate1;
	@Column
	private String s1daydate2;
	@Column
	private String s1daydate3;
	@Column
	private String s1daydate4;
	@Column
	private String s1daydate5;
	@Column
	private String s1daydate6;
	@Column
	private String s1daydate7;
	@Column
	private String s1dayupload1;
	@Column
	private String s1dayupload2;
	@Column
	private String s1dayupload3;
	@Column
	private String s1dayupload4;
	@Column
	private String s1dayupload5;
	@Column
	private String s1dayupload6;
	@Column
	private String s1dayupload7;
	@Column
	private String s1daydownload1;
	@Column
	private String s1daydownload2;
	@Column
	private String s1daydownload3;
	@Column
	private String s1daydownload4;
	@Column
	private String s1daydownload5;
	@Column
	private String s1daydownload6;
	@Column
	private String s1daydownload7;
	@Column
	private String s2daydate1;
	@Column
	private String s2daydate2;
	@Column
	private String s2daydate3;
	@Column
	private String s2daydate4;
	@Column
	private String s2daydate5;
	@Column
	private String s2daydate6;
	@Column
	private String s2daydate7;
	@Column
	private String s2dayupload1;
	@Column
	private String s2dayupload2;
	@Column
	private String s2dayupload3;
	@Column
	private String s2dayupload4;
	@Column
	private String s2dayupload5;
	@Column
	private String s2dayupload6;
	@Column
	private String s2dayupload7;
	@Column
	private String s2daydownload1;
	@Column
	private String s2daydownload2;
	@Column
	private String s2daydownload3;
	@Column
	private String s2daydownload4;
	@Column
	private String s2daydownload5;
	@Column
	private String s2daydownload6;
	@Column
	private String s2daydownload7;
	@Column
	private String s1weekdate1;
	@Column
	private String s1weekdate2;
	@Column
	private String s1weekdate3;
	@Column
	private String s1weekdate4;
	@Column
	private String s1weekdate5;
	@Column
	private String s1weekdate6;
	@Column
	private String s1weekdate7;
	@Column
	private String s1weekupload1;
	@Column
	private String s1weekupload2;
	@Column
	private String s1weekupload3;
	@Column
	private String s1weekupload4;
	@Column
	private String s1weekupload5;
	@Column
	private String s1weekupload6;
	@Column
	private String s1weekupload7;
	@Column
	private String s1weekdownload1;
	@Column
	private String s1weekdownload2;
	@Column
	private String s1weekdownload3;
	@Column
	private String s1weekdownload4;
	@Column
	private String s1weekdownload5;
	@Column
	private String s1weekdownload6;
	@Column
	private String s1weekdownload7;
	@Column
	private String s2weekdate1;
	@Column
	private String s2weekdate2;
	@Column
	private String s2weekdate3;
	@Column
	private String s2weekdate4;
	@Column
	private String s2weekdate5;
	@Column
	private String s2weekdate6;
	@Column
	private String s2weekdate7;
	@Column
	private String s2weekupload1;
	@Column
	private String s2weekupload2;
	@Column
	private String s2weekupload3;
	@Column
	private String s2weekupload4;
	@Column
	private String s2weekupload5;
	@Column
	private String s2weekupload6;
	@Column
	private String s2weekupload7;
	@Column
	private String s2weekdownload1;
	@Column
	private String s2weekdownload2;
	@Column
	private String s2weekdownload3;
	@Column
	private String s2weekdownload4;
	@Column
	private String s2weekdownload5;
	@Column
	private String s2weekdownload6;
	@Column
	private String s2weekdownload7;
	@Column
	private String s1monthdate1;
	@Column
	private String s1monthdate2;
	@Column
	private String s1monthdate3;
	@Column
	private String s1monthdate4;
	@Column
	private String s1monthdate5;
	@Column
	private String s1monthdate6;
	@Column
	private String s1monthdate7;
	@Column
	private String s1monthupload1;
	@Column
	private String s1monthupload2;
	@Column
	private String s1monthupload3;
	@Column
	private String s1monthupload4;
	@Column
	private String s1monthupload5;
	@Column
	private String s1monthupload6;
	@Column
	private String s1monthupload7;
	@Column
	private String s1monthdownload1;
	@Column
	private String s1monthdownload2;
	@Column
	private String s1monthdownload3;
	@Column
	private String s1monthdownload4;
	@Column
	private String s1monthdownload5;
	@Column
	private String s1monthdownload6;
	@Column
	private String s1monthdownload7;
	@Column
	private String s2monthdate1;
	@Column
	private String s2monthdate2;
	@Column
	private String s2monthdate3;
	@Column
	private String s2monthdate4;
	@Column
	private String s2monthdate5;
	@Column
	private String s2monthdate6;
	@Column
	private String s2monthdate7;
	@Column
	private String s2monthupload1;
	@Column
	private String s2monthupload2;
	@Column
	private String s2monthupload3;
	@Column
	private String s2monthupload4;
	@Column
	private String s2monthupload5;
	@Column
	private String s2monthupload6;
	@Column
	private String s2monthupload7;
	@Column
	private String s2monthdownload1;
	@Column
	private String s2monthdownload2;
	@Column
	private String s2monthdownload3;
	@Column
	private String s2monthdownload4;
	@Column
	private String s2monthdownload5;
	@Column
	private String s2monthdownload6;
	@Column
	private String s2monthdownload7;
	@Column
	private String slnumber;
	public String getSlnumber() {
		return slnumber;
	}
	public void setSlnumber(String slnumber) {
		this.slnumber = slnumber;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getS1daydate1() {
		return s1daydate1;
	}
	public void setS1daydate1(String s1daydate1) {
		this.s1daydate1 = s1daydate1;
	}
	public String getS1daydate2() {
		return s1daydate2;
	}
	public void setS1daydate2(String s1daydate2) {
		this.s1daydate2 = s1daydate2;
	}
	public String getS1daydate3() {
		return s1daydate3;
	}
	public void setS1daydate3(String s1daydate3) {
		this.s1daydate3 = s1daydate3;
	}
	public String getS1daydate4() {
		return s1daydate4;
	}
	public void setS1daydate4(String s1daydate4) {
		this.s1daydate4 = s1daydate4;
	}
	public String getS1daydate5() {
		return s1daydate5;
	}
	public void setS1daydate5(String s1daydate5) {
		this.s1daydate5 = s1daydate5;
	}
	public String getS1daydate6() {
		return s1daydate6;
	}
	public void setS1daydate6(String s1daydate6) {
		this.s1daydate6 = s1daydate6;
	}
	public String getS1daydate7() {
		return s1daydate7;
	}
	public void setS1daydate7(String s1daydate7) {
		this.s1daydate7 = s1daydate7;
	}
	public String getS1dayupload1() {
		return s1dayupload1;
	}
	public void setS1dayupload1(String s1dayupload1) {
		this.s1dayupload1 = s1dayupload1;
	}
	public String getS1dayupload2() {
		return s1dayupload2;
	}
	public void setS1dayupload2(String s1dayupload2) {
		this.s1dayupload2 = s1dayupload2;
	}
	public String getS1dayupload3() {
		return s1dayupload3;
	}
	public void setS1dayupload3(String s1dayupload3) {
		this.s1dayupload3 = s1dayupload3;
	}
	public String getS1dayupload4() {
		return s1dayupload4;
	}
	public void setS1dayupload4(String s1dayupload4) {
		this.s1dayupload4 = s1dayupload4;
	}
	public String getS1dayupload5() {
		return s1dayupload5;
	}
	public void setS1dayupload5(String s1dayupload5) {
		this.s1dayupload5 = s1dayupload5;
	}
	public String getS1dayupload6() {
		return s1dayupload6;
	}
	public void setS1dayupload6(String s1dayupload6) {
		this.s1dayupload6 = s1dayupload6;
	}
	public String getS1dayupload7() {
		return s1dayupload7;
	}
	public void setS1dayupload7(String s1dayupload7) {
		this.s1dayupload7 = s1dayupload7;
	}
	public String getS1daydownload1() {
		return s1daydownload1;
	}
	public void setS1daydownload1(String s1daydownload1) {
		this.s1daydownload1 = s1daydownload1;
	}
	public String getS1daydownload2() {
		return s1daydownload2;
	}
	public void setS1daydownload2(String s1daydownload2) {
		this.s1daydownload2 = s1daydownload2;
	}
	public String getS1daydownload3() {
		return s1daydownload3;
	}
	public void setS1daydownload3(String s1daydownload3) {
		this.s1daydownload3 = s1daydownload3;
	}
	public String getS1daydownload4() {
		return s1daydownload4;
	}
	public void setS1daydownload4(String s1daydownload4) {
		this.s1daydownload4 = s1daydownload4;
	}
	public String getS1daydownload5() {
		return s1daydownload5;
	}
	public void setS1daydownload5(String s1daydownload5) {
		this.s1daydownload5 = s1daydownload5;
	}
	public String getS1daydownload6() {
		return s1daydownload6;
	}
	public void setS1daydownload6(String s1daydownload6) {
		this.s1daydownload6 = s1daydownload6;
	}
	public String getS1daydownload7() {
		return s1daydownload7;
	}
	public void setS1daydownload7(String s1daydownload7) {
		this.s1daydownload7 = s1daydownload7;
	}
	public String getS2daydate1() {
		return s2daydate1;
	}
	public void setS2daydate1(String s2daydate1) {
		this.s2daydate1 = s2daydate1;
	}
	public String getS2daydate2() {
		return s2daydate2;
	}
	public void setS2daydate2(String s2daydate2) {
		this.s2daydate2 = s2daydate2;
	}
	public String getS2daydate3() {
		return s2daydate3;
	}
	public void setS2daydate3(String s2daydate3) {
		this.s2daydate3 = s2daydate3;
	}
	public String getS2daydate4() {
		return s2daydate4;
	}
	public void setS2daydate4(String s2daydate4) {
		this.s2daydate4 = s2daydate4;
	}
	public String getS2daydate5() {
		return s2daydate5;
	}
	public void setS2daydate5(String s2daydate5) {
		this.s2daydate5 = s2daydate5;
	}
	public String getS2daydate6() {
		return s2daydate6;
	}
	public void setS2daydate6(String s2daydate6) {
		this.s2daydate6 = s2daydate6;
	}
	public String getS2daydate7() {
		return s2daydate7;
	}
	public void setS2daydate7(String s2daydate7) {
		this.s2daydate7 = s2daydate7;
	}
	public String getS2dayupload1() {
		return s2dayupload1;
	}
	public void setS2dayupload1(String s2dayupload1) {
		this.s2dayupload1 = s2dayupload1;
	}
	public String getS2dayupload2() {
		return s2dayupload2;
	}
	public void setS2dayupload2(String s2dayupload2) {
		this.s2dayupload2 = s2dayupload2;
	}
	public String getS2dayupload3() {
		return s2dayupload3;
	}
	public void setS2dayupload3(String s2dayupload3) {
		this.s2dayupload3 = s2dayupload3;
	}
	public String getS2dayupload4() {
		return s2dayupload4;
	}
	public void setS2dayupload4(String s2dayupload4) {
		this.s2dayupload4 = s2dayupload4;
	}
	public String getS2dayupload5() {
		return s2dayupload5;
	}
	public void setS2dayupload5(String s2dayupload5) {
		this.s2dayupload5 = s2dayupload5;
	}
	public String getS2dayupload6() {
		return s2dayupload6;
	}
	public void setS2dayupload6(String s2dayupload6) {
		this.s2dayupload6 = s2dayupload6;
	}
	public String getS2dayupload7() {
		return s2dayupload7;
	}
	public void setS2dayupload7(String s2dayupload7) {
		this.s2dayupload7 = s2dayupload7;
	}
	public String getS2daydownload1() {
		return s2daydownload1;
	}
	public void setS2daydownload1(String s2daydownload1) {
		this.s2daydownload1 = s2daydownload1;
	}
	public String getS2daydownload2() {
		return s2daydownload2;
	}
	public void setS2daydownload2(String s2daydownload2) {
		this.s2daydownload2 = s2daydownload2;
	}
	public String getS2daydownload3() {
		return s2daydownload3;
	}
	public void setS2daydownload3(String s2daydownload3) {
		this.s2daydownload3 = s2daydownload3;
	}
	public String getS2daydownload4() {
		return s2daydownload4;
	}
	public void setS2daydownload4(String s2daydownload4) {
		this.s2daydownload4 = s2daydownload4;
	}
	public String getS2daydownload5() {
		return s2daydownload5;
	}
	public void setS2daydownload5(String s2daydownload5) {
		this.s2daydownload5 = s2daydownload5;
	}
	public String getS2daydownload6() {
		return s2daydownload6;
	}
	public void setS2daydownload6(String s2daydownload6) {
		this.s2daydownload6 = s2daydownload6;
	}
	public String getS2daydownload7() {
		return s2daydownload7;
	}
	public void setS2daydownload7(String s2daydownload7) {
		this.s2daydownload7 = s2daydownload7;
	}
	public String getS1weekdate1() {
		return s1weekdate1;
	}
	public void setS1weekdate1(String s1weekdate1) {
		this.s1weekdate1 = s1weekdate1;
	}
	public String getS1weekdate2() {
		return s1weekdate2;
	}
	public void setS1weekdate2(String s1weekdate2) {
		this.s1weekdate2 = s1weekdate2;
	}
	public String getS1weekdate3() {
		return s1weekdate3;
	}
	public void setS1weekdate3(String s1weekdate3) {
		this.s1weekdate3 = s1weekdate3;
	}
	public String getS1weekdate4() {
		return s1weekdate4;
	}
	public void setS1weekdate4(String s1weekdate4) {
		this.s1weekdate4 = s1weekdate4;
	}
	public String getS1weekdate5() {
		return s1weekdate5;
	}
	public void setS1weekdate5(String s1weekdate5) {
		this.s1weekdate5 = s1weekdate5;
	}
	public String getS1weekdate6() {
		return s1weekdate6;
	}
	public void setS1weekdate6(String s1weekdate6) {
		this.s1weekdate6 = s1weekdate6;
	}
	public String getS1weekdate7() {
		return s1weekdate7;
	}
	public void setS1weekdate7(String s1weekdate7) {
		this.s1weekdate7 = s1weekdate7;
	}
	public String getS1weekupload1() {
		return s1weekupload1;
	}
	public void setS1weekupload1(String s1weekupload1) {
		this.s1weekupload1 = s1weekupload1;
	}
	public String getS1weekupload2() {
		return s1weekupload2;
	}
	public void setS1weekupload2(String s1weekupload2) {
		this.s1weekupload2 = s1weekupload2;
	}
	public String getS1weekupload3() {
		return s1weekupload3;
	}
	public void setS1weekupload3(String s1weekupload3) {
		this.s1weekupload3 = s1weekupload3;
	}
	public String getS1weekupload4() {
		return s1weekupload4;
	}
	public void setS1weekupload4(String s1weekupload4) {
		this.s1weekupload4 = s1weekupload4;
	}
	public String getS1weekupload5() {
		return s1weekupload5;
	}
	public void setS1weekupload5(String s1weekupload5) {
		this.s1weekupload5 = s1weekupload5;
	}
	public String getS1weekupload6() {
		return s1weekupload6;
	}
	public void setS1weekupload6(String s1weekupload6) {
		this.s1weekupload6 = s1weekupload6;
	}
	public String getS1weekupload7() {
		return s1weekupload7;
	}
	public void setS1weekupload7(String s1weekupload7) {
		this.s1weekupload7 = s1weekupload7;
	}
	public String getS1weekdownload1() {
		return s1weekdownload1;
	}
	public void setS1weekdownload1(String s1weekdownload1) {
		this.s1weekdownload1 = s1weekdownload1;
	}
	public String getS1weekdownload2() {
		return s1weekdownload2;
	}
	public void setS1weekdownload2(String s1weekdownload2) {
		this.s1weekdownload2 = s1weekdownload2;
	}
	public String getS1weekdownload3() {
		return s1weekdownload3;
	}
	public void setS1weekdownload3(String s1weekdownload3) {
		this.s1weekdownload3 = s1weekdownload3;
	}
	public String getS1weekdownload4() {
		return s1weekdownload4;
	}
	public void setS1weekdownload4(String s1weekdownload4) {
		this.s1weekdownload4 = s1weekdownload4;
	}
	public String getS1weekdownload5() {
		return s1weekdownload5;
	}
	public void setS1weekdownload5(String s1weekdownload5) {
		this.s1weekdownload5 = s1weekdownload5;
	}
	public String getS1weekdownload6() {
		return s1weekdownload6;
	}
	public void setS1weekdownload6(String s1weekdownload6) {
		this.s1weekdownload6 = s1weekdownload6;
	}
	public String getS1weekdownload7() {
		return s1weekdownload7;
	}
	public void setS1weekdownload7(String s1weekdownload7) {
		this.s1weekdownload7 = s1weekdownload7;
	}
	public String getS2weekdate1() {
		return s2weekdate1;
	}
	public void setS2weekdate1(String s2weekdate1) {
		this.s2weekdate1 = s2weekdate1;
	}
	public String getS2weekdate2() {
		return s2weekdate2;
	}
	public void setS2weekdate2(String s2weekdate2) {
		this.s2weekdate2 = s2weekdate2;
	}
	public String getS2weekdate3() {
		return s2weekdate3;
	}
	public void setS2weekdate3(String s2weekdate3) {
		this.s2weekdate3 = s2weekdate3;
	}
	public String getS2weekdate4() {
		return s2weekdate4;
	}
	public void setS2weekdate4(String s2weekdate4) {
		this.s2weekdate4 = s2weekdate4;
	}
	public String getS2weekdate5() {
		return s2weekdate5;
	}
	public void setS2weekdate5(String s2weekdate5) {
		this.s2weekdate5 = s2weekdate5;
	}
	public String getS2weekdate6() {
		return s2weekdate6;
	}
	public void setS2weekdate6(String s2weekdate6) {
		this.s2weekdate6 = s2weekdate6;
	}
	public String getS2weekdate7() {
		return s2weekdate7;
	}
	public void setS2weekdate7(String s2weekdate7) {
		this.s2weekdate7 = s2weekdate7;
	}
	public String getS2weekupload1() {
		return s2weekupload1;
	}
	public void setS2weekupload1(String s2weekupload1) {
		this.s2weekupload1 = s2weekupload1;
	}
	public String getS2weekupload2() {
		return s2weekupload2;
	}
	public void setS2weekupload2(String s2weekupload2) {
		this.s2weekupload2 = s2weekupload2;
	}
	public String getS2weekupload3() {
		return s2weekupload3;
	}
	public void setS2weekupload3(String s2weekupload3) {
		this.s2weekupload3 = s2weekupload3;
	}
	public String getS2weekupload4() {
		return s2weekupload4;
	}
	public void setS2weekupload4(String s2weekupload4) {
		this.s2weekupload4 = s2weekupload4;
	}
	public String getS2weekupload5() {
		return s2weekupload5;
	}
	public void setS2weekupload5(String s2weekupload5) {
		this.s2weekupload5 = s2weekupload5;
	}
	public String getS2weekupload6() {
		return s2weekupload6;
	}
	public void setS2weekupload6(String s2weekupload6) {
		this.s2weekupload6 = s2weekupload6;
	}
	public String getS2weekupload7() {
		return s2weekupload7;
	}
	public void setS2weekupload7(String s2weekupload7) {
		this.s2weekupload7 = s2weekupload7;
	}
	public String getS2weekdownload1() {
		return s2weekdownload1;
	}
	public void setS2weekdownload1(String s2weekdownload1) {
		this.s2weekdownload1 = s2weekdownload1;
	}
	public String getS2weekdownload2() {
		return s2weekdownload2;
	}
	public void setS2weekdownload2(String s2weekdownload2) {
		this.s2weekdownload2 = s2weekdownload2;
	}
	public String getS2weekdownload3() {
		return s2weekdownload3;
	}
	public void setS2weekdownload3(String s2weekdownload3) {
		this.s2weekdownload3 = s2weekdownload3;
	}
	public String getS2weekdownload4() {
		return s2weekdownload4;
	}
	public void setS2weekdownload4(String s2weekdownload4) {
		this.s2weekdownload4 = s2weekdownload4;
	}
	public String getS2weekdownload5() {
		return s2weekdownload5;
	}
	public void setS2weekdownload5(String s2weekdownload5) {
		this.s2weekdownload5 = s2weekdownload5;
	}
	public String getS2weekdownload6() {
		return s2weekdownload6;
	}
	public void setS2weekdownload6(String s2weekdownload6) {
		this.s2weekdownload6 = s2weekdownload6;
	}
	public String getS2weekdownload7() {
		return s2weekdownload7;
	}
	public void setS2weekdownload7(String s2weekdownload7) {
		this.s2weekdownload7 = s2weekdownload7;
	}
	public String getS1monthdate1() {
		return s1monthdate1;
	}
	public void setS1monthdate1(String s1monthdate1) {
		this.s1monthdate1 = s1monthdate1;
	}
	public String getS1monthdate2() {
		return s1monthdate2;
	}
	public void setS1monthdate2(String s1monthdate2) {
		this.s1monthdate2 = s1monthdate2;
	}
	public String getS1monthdate3() {
		return s1monthdate3;
	}
	public void setS1monthdate3(String s1monthdate3) {
		this.s1monthdate3 = s1monthdate3;
	}
	public String getS1monthdate4() {
		return s1monthdate4;
	}
	public void setS1monthdate4(String s1monthdate4) {
		this.s1monthdate4 = s1monthdate4;
	}
	public String getS1monthdate5() {
		return s1monthdate5;
	}
	public void setS1monthdate5(String s1monthdate5) {
		this.s1monthdate5 = s1monthdate5;
	}
	public String getS1monthdate6() {
		return s1monthdate6;
	}
	public void setS1monthdate6(String s1monthdate6) {
		this.s1monthdate6 = s1monthdate6;
	}
	public String getS1monthdate7() {
		return s1monthdate7;
	}
	public void setS1monthdate7(String s1monthdate7) {
		this.s1monthdate7 = s1monthdate7;
	}
	public String getS1monthupload1() {
		return s1monthupload1;
	}
	public void setS1monthupload1(String s1monthupload1) {
		this.s1monthupload1 = s1monthupload1;
	}
	public String getS1monthupload2() {
		return s1monthupload2;
	}
	public void setS1monthupload2(String s1monthupload2) {
		this.s1monthupload2 = s1monthupload2;
	}
	public String getS1monthupload3() {
		return s1monthupload3;
	}
	public void setS1monthupload3(String s1monthupload3) {
		this.s1monthupload3 = s1monthupload3;
	}
	public String getS1monthupload4() {
		return s1monthupload4;
	}
	public void setS1monthupload4(String s1monthupload4) {
		this.s1monthupload4 = s1monthupload4;
	}
	public String getS1monthupload5() {
		return s1monthupload5;
	}
	public void setS1monthupload5(String s1monthupload5) {
		this.s1monthupload5 = s1monthupload5;
	}
	public String getS1monthupload6() {
		return s1monthupload6;
	}
	public void setS1monthupload6(String s1monthupload6) {
		this.s1monthupload6 = s1monthupload6;
	}
	public String getS1monthupload7() {
		return s1monthupload7;
	}
	public void setS1monthupload7(String s1monthupload7) {
		this.s1monthupload7 = s1monthupload7;
	}
	public String getS1monthdownload1() {
		return s1monthdownload1;
	}
	public void setS1monthdownload1(String s1monthdownload1) {
		this.s1monthdownload1 = s1monthdownload1;
	}
	public String getS1monthdownload2() {
		return s1monthdownload2;
	}
	public void setS1monthdownload2(String s1monthdownload2) {
		this.s1monthdownload2 = s1monthdownload2;
	}
	public String getS1monthdownload3() {
		return s1monthdownload3;
	}
	public void setS1monthdownload3(String s1monthdownload3) {
		this.s1monthdownload3 = s1monthdownload3;
	}
	public String getS1monthdownload4() {
		return s1monthdownload4;
	}
	public void setS1monthdownload4(String s1monthdownload4) {
		this.s1monthdownload4 = s1monthdownload4;
	}
	public String getS1monthdownload5() {
		return s1monthdownload5;
	}
	public void setS1monthdownload5(String s1monthdownload5) {
		this.s1monthdownload5 = s1monthdownload5;
	}
	public String getS1monthdownload6() {
		return s1monthdownload6;
	}
	public void setS1monthdownload6(String s1monthdownload6) {
		this.s1monthdownload6 = s1monthdownload6;
	}
	public String getS1monthdownload7() {
		return s1monthdownload7;
	}
	public void setS1monthdownload7(String s1monthdownload7) {
		this.s1monthdownload7 = s1monthdownload7;
	}
	public String getS2monthdate1() {
		return s2monthdate1;
	}
	public void setS2monthdate1(String s2monthdate1) {
		this.s2monthdate1 = s2monthdate1;
	}
	public String getS2monthdate2() {
		return s2monthdate2;
	}
	public void setS2monthdate2(String s2monthdate2) {
		this.s2monthdate2 = s2monthdate2;
	}
	public String getS2monthdate3() {
		return s2monthdate3;
	}
	public void setS2monthdate3(String s2monthdate3) {
		this.s2monthdate3 = s2monthdate3;
	}
	public String getS2monthdate4() {
		return s2monthdate4;
	}
	public void setS2monthdate4(String s2monthdate4) {
		this.s2monthdate4 = s2monthdate4;
	}
	public String getS2monthdate5() {
		return s2monthdate5;
	}
	public void setS2monthdate5(String s2monthdate5) {
		this.s2monthdate5 = s2monthdate5;
	}
	public String getS2monthdate6() {
		return s2monthdate6;
	}
	public void setS2monthdate6(String s2monthdate6) {
		this.s2monthdate6 = s2monthdate6;
	}
	public String getS2monthdate7() {
		return s2monthdate7;
	}
	public void setS2monthdate7(String s2monthdate7) {
		this.s2monthdate7 = s2monthdate7;
	}
	public String getS2monthupload1() {
		return s2monthupload1;
	}
	public void setS2monthupload1(String s2monthupload1) {
		this.s2monthupload1 = s2monthupload1;
	}
	public String getS2monthupload2() {
		return s2monthupload2;
	}
	public void setS2monthupload2(String s2monthupload2) {
		this.s2monthupload2 = s2monthupload2;
	}
	public String getS2monthupload3() {
		return s2monthupload3;
	}
	public void setS2monthupload3(String s2monthupload3) {
		this.s2monthupload3 = s2monthupload3;
	}
	public String getS2monthupload4() {
		return s2monthupload4;
	}
	public void setS2monthupload4(String s2monthupload4) {
		this.s2monthupload4 = s2monthupload4;
	}
	public String getS2monthupload5() {
		return s2monthupload5;
	}
	public void setS2monthupload5(String s2monthupload5) {
		this.s2monthupload5 = s2monthupload5;
	}
	public String getS2monthupload6() {
		return s2monthupload6;
	}
	public void setS2monthupload6(String s2monthupload6) {
		this.s2monthupload6 = s2monthupload6;
	}
	public String getS2monthupload7() {
		return s2monthupload7;
	}
	public void setS2monthupload7(String s2monthupload7) {
		this.s2monthupload7 = s2monthupload7;
	}
	public String getS2monthdownload1() {
		return s2monthdownload1;
	}
	public void setS2monthdownload1(String s2monthdownload1) {
		this.s2monthdownload1 = s2monthdownload1;
	}
	public String getS2monthdownload2() {
		return s2monthdownload2;
	}
	public void setS2monthdownload2(String s2monthdownload2) {
		this.s2monthdownload2 = s2monthdownload2;
	}
	public String getS2monthdownload3() {
		return s2monthdownload3;
	}
	public void setS2monthdownload3(String s2monthdownload3) {
		this.s2monthdownload3 = s2monthdownload3;
	}
	public String getS2monthdownload4() {
		return s2monthdownload4;
	}
	public void setS2monthdownload4(String s2monthdownload4) {
		this.s2monthdownload4 = s2monthdownload4;
	}
	public String getS2monthdownload5() {
		return s2monthdownload5;
	}
	public void setS2monthdownload5(String s2monthdownload5) {
		this.s2monthdownload5 = s2monthdownload5;
	}
	public String getS2monthdownload6() {
		return s2monthdownload6;
	}
	public void setS2monthdownload6(String s2monthdownload6) {
		this.s2monthdownload6 = s2monthdownload6;
	}
	public String getS2monthdownload7() {
		return s2monthdownload7;
	}
	public void setS2monthdownload7(String s2monthdownload7) {
		this.s2monthdownload7 = s2monthdownload7;
	}
	
}
