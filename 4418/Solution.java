import java.util.ArrayList;
import java.util.Collections;
import java.util.Scanner;


public class Solution {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String input = new String(sc.nextLine());
        ArrayList<String> left = Formate_input(input.split(" seq ")[0]);
        ArrayList<String> right = Formate_input(input.split(" seq ")[1]);
        ArrayList<String> proof = new ArrayList<>();
        DFS(left, right, proof);
    }

    public static ArrayList<String> Formate_input(String str) {
        ArrayList<String> result = new ArrayList<>();
        str = str.replace("]", "");
        str = str.replace("[", "");
        if (str.length() == 0) {
            return result;
        }
        if (!str.contains(",")) {
            result.add(str);
            return result;
        }
        String[] array = str.split(", ");
        for(String string : array) {
            result.add(string);
        }
        return result;
    }

    public static boolean DFS(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        /** rule 1 */
        for (String element : left) {
            if (right.contains(element)) {
                proof.add(oneline(left, right) + "            Rule 1");
                System.out.println(true);
                Collections.reverse(proof);
                for (String str : proof) {
                    System.out.println(str);
                }
                return true;
            }
        }
        /** return false */
        if (single_check(left, right)) {
            return false;
        }
        /** Apply following rules */
        rule_2a(left, right, proof);
        rule_2b(left, right, proof);
        if (rule_3a(left, right, proof)) {
            return true;
        }
        rule_3b(left, right, proof);
        rule_4a(left, right, proof);
        if (rule_4b(left, right, proof)) {
            return true;
        }
        rule_5a(left, right, proof);
        if (rule_5b(left, right, proof)) {
            return true;
        }
        if (rule_6a(left, right, proof)) {
            return true;
        }
        if (rule_6b(left, right, proof)) {
            return true;
        }
        return false;
    }

    /** use for print the output */
    public static String oneline(ArrayList<String> left, ArrayList<String> right) {
        String result = "";
        for (String str : left) {
            result += str + ", ";
        }
        result += " seq ";
        for (String str : right) {
            result += str + ", ";
        }
        return result;
    }

    /** use for false check when both sides only contains single atomic without "neg" */
    public static boolean single_check(ArrayList<String> left, ArrayList<String> right) {
        for (String element : left) {
            if (element.contains("and") || element.contains("or") || element.contains("neg") ||
                    element.contains("imp") || element.contains("iff")){
                return false;
            }
        }
        for (String element : right) {
            if (element.contains("and") || element.contains("or") || element.contains("neg") ||
                    element.contains("imp") || element.contains("iff")){
                return false;
            }
        }
        return true;
    }

    public static void rule_2a(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < right.size(); i++) {
            if (right.get(i).contains("neg")) {
                if (right.get(i).contains("and") || right.get(i).contains("or") ||
                        right.get(i).contains("imp") || right.get(i).contains("iff")) {
                    if (right.get(i).startsWith("neg(") && right.get(i).endsWith(")")) {
                        ArrayList<String> new_left = new ArrayList<>(left);
                        ArrayList<String> new_right = new ArrayList<>(right);
                        ArrayList<String> new_proof = new ArrayList<>(proof);
                        String change = right.get(i);
                        change = change.substring(4, change.length() - 1);
                        new_right.remove(i);
                        new_left.add(change);
                        new_proof.add(oneline(left, right) + "            Rule 2a");
                        DFS(new_left, new_right, new_proof);
                    }
                } else {
                    ArrayList<String> new_left = new ArrayList<>(left);
                    ArrayList<String> new_right = new ArrayList<>(right);
                    ArrayList<String> new_proof = new ArrayList<>(proof);
                    String change = right.get(i);
                    change = change.replace("neg", "");
                    change = change.replace(" ", "");
                    change = change.replace("(", "");
                    change = change.replace(")", "");
                    new_right.remove(i);
                    new_left.add(change);
                    new_proof.add(oneline(left, right) + "            Rule 2a");
                    DFS(new_left, new_right, new_proof);
                }
            }
        }
    }

    public static void rule_2b(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < left.size(); i++) {
            if (left.get(i).contains("neg")) {
                if (left.get(i).contains("and") || left.get(i).contains("or") ||
                        left.get(i).contains("imp") || left.get(i).contains("iff")) {
                    if (left.get(i).startsWith("neg(") && left.get(i).endsWith(")")) {
                        ArrayList<String> new_left = new ArrayList<>(left);
                        ArrayList<String> new_right = new ArrayList<>(right);
                        ArrayList<String> new_proof = new ArrayList<>(proof);
                        String change = left.get(i);
                        change = change.substring(4, change.length() - 1);
                        new_left.remove(i);
                        new_right.add(change);
                        new_proof.add(oneline(left, right) + "            Rule 2b");
                        DFS(new_left, new_right, new_proof);
                    }
                } else {
                    ArrayList<String> new_left = new ArrayList<>(left);
                    ArrayList<String> new_right = new ArrayList<>(right);
                    ArrayList<String> new_proof = new ArrayList<>(proof);
                    String change = left.get(i);
                    change = change.replace("neg", "");
                    change = change.replace(" ", "");
                    change = change.replace("(", "");
                    change = change.replace(")", "");
                    new_left.remove(i);
                    new_right.add(change);
                    new_proof.add(oneline(left, right) + "            Rule 2b");
                    DFS(new_left, new_right, new_proof);
                }
            }
        }
    }

    public static boolean rule_3a(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < right.size(); i++) {
            if (right.get(i).contains("and") && !(right.get(i).startsWith("neg("))) {
                String change = right.get(i);
                String left_part = brackets(change, "and").get(0);
                String right_part = brackets(change, "and").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_right.remove(i);
                new_right.add(left_part);
                new_proof.add(oneline(left, right) + "            Rule 3a");
                ArrayList<String> new_left_2 = new ArrayList<>(left);
                ArrayList<String> new_right_2 = new ArrayList<>(right);
                ArrayList<String> new_proof_2 = new ArrayList<>(proof);
                new_right_2.remove(i);
                new_right_2.add(right_part);
                new_proof_2.add(oneline(left, right) + "            Rule 3a");
                if (DFS(new_left_2, new_right_2, new_proof_2) && DFS(new_left, new_right, new_proof)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static void rule_3b(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < left.size(); i++) {
            if (left.get(i).contains("and") && !(left.get(i).startsWith("neg("))) {
                String change = left.get(i);
                String left_part = brackets(change, "and").get(0);
                String right_part = brackets(change, "and").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_left.remove(i);
                new_left.add(left_part);
                new_left.add(right_part);
                new_proof.add(oneline(left, right) + "            Rule 3b");
                DFS(new_left, new_right, new_proof);
            }
        }
    }

    public static void rule_4a(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < right.size(); i++) {
            if (right.get(i).contains("or") && !(right.get(i).startsWith("neg("))) {
                String change = right.get(i);
                String left_part = brackets(change, "or").get(0);
                String right_part = brackets(change, "or").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_right.remove(i);
                new_right.add(left_part);
                new_right.add(right_part);
                new_proof.add(oneline(left, right) + "            Rule 4a");
                DFS(new_left, new_right, new_proof);
            }
        }
    }

    public static boolean rule_4b(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < left.size(); i++) {
            if (left.get(i).contains("or") && !(left.get(i).startsWith("neg("))) {
                String change = left.get(i);
                String left_part = brackets(change, "or").get(0);
                String right_part = brackets(change, "or").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_left.remove(i);
                new_left.add(left_part);
                new_proof.add(oneline(left, right) + "            Rule 4b");
                ArrayList<String> new_left_2 = new ArrayList<>(left);
                ArrayList<String> new_right_2 = new ArrayList<>(right);
                ArrayList<String> new_proof_2 = new ArrayList<>(proof);
                new_left_2.remove(i);
                new_left_2.add(right_part);
                new_proof_2.add(oneline(left, right) + "            Rule 4b");
                if (DFS(new_left, new_right, new_proof) && DFS(new_left_2, new_right_2, new_proof_2)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static void rule_5a(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < right.size(); i++) {
            if (right.get(i).contains("imply") && !(right.get(i).startsWith("neg("))) {
                String change = right.get(i);
                String left_part = brackets(change, "imply").get(0);
                String right_part = brackets(change, "imply").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_right.remove(i);
                new_right.add(right_part);
                new_left.add(left_part);
                new_proof.add(oneline(left, right) + "            Rule 5a");
                DFS(new_left, new_right, new_proof);
            }
        }
    }

    public static boolean rule_5b(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < left.size(); i++) {
            if (left.get(i).contains("imply") && !(left.get(i).startsWith("neg("))) {
                String change = left.get(i);
                String left_part = brackets(change, "imply").get(0);
                String right_part = brackets(change, "imply").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_left.remove(i);
                new_left.add(right_part);
                new_proof.add(oneline(left, right) + "            Rule 5b");
                ArrayList<String> new_left_2 = new ArrayList<>(left);
                ArrayList<String> new_right_2 = new ArrayList<>(right);
                ArrayList<String> new_proof_2 = new ArrayList<>(proof);
                new_left_2.remove(i);
                new_right_2.add(left_part);
                new_proof_2.add(oneline(left, right) + "            Rule 5b");
                if (DFS(new_left, new_right, new_proof) && DFS(new_left_2, new_right_2, new_proof_2)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean rule_6a(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < right.size(); i++) {
            if (right.get(i).contains("iff") && !(right.get(i).startsWith("neg("))) {
                String change = right.get(i);
                String left_part = brackets(change, "iff").get(0);
                String right_part = brackets(change, "iff").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_right.remove(i);
                new_right.add(right_part);
                new_left.add(left_part);
                new_proof.add(oneline(left, right) + "            Rule 6a");
                ArrayList<String> new_left_2 = new ArrayList<>(left);
                ArrayList<String> new_right_2 = new ArrayList<>(right);
                ArrayList<String> new_proof_2 = new ArrayList<>(proof);
                new_right_2.remove(i);
                new_right_2.add(left_part);
                new_left_2.add(right_part);
                new_proof_2.add(oneline(left, right) + "            Rule 6a");
                if (DFS(new_left, new_right, new_proof) && DFS(new_left_2, new_right_2, new_proof_2)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean rule_6b(ArrayList<String> left, ArrayList<String> right, ArrayList<String> proof) {
        for (int i = 0; i < left.size(); i++) {
            if (left.get(i).contains("iff") && !(left.get(i).startsWith("neg("))) {
                String change = left.get(i);
                String left_part = brackets(change, "iff").get(0);
                String right_part = brackets(change, "iff").get(1);
                ArrayList<String> new_left = new ArrayList<>(left);
                ArrayList<String> new_right = new ArrayList<>(right);
                ArrayList<String> new_proof = new ArrayList<>(proof);
                new_left.remove(i);
                new_left.add(left_part);
                new_left.add(right_part);
                new_proof.add(oneline(left, right) + "            Rule 6b");
                ArrayList<String> new_left_2 = new ArrayList<>(left);
                ArrayList<String> new_right_2 = new ArrayList<>(right);
                ArrayList<String> new_proof_2 = new ArrayList<>(proof);
                new_left_2.remove(i);
                new_right_2.add(left_part);
                new_right_2.add(right_part);
                new_proof_2.add(oneline(left, right) + "            Rule 6b");
                if (DFS(new_left, new_right, new_proof) && DFS(new_left_2, new_right_2, new_proof_2)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static ArrayList<String> brackets(String input, String operation) {
        ArrayList<String> result = new ArrayList<>();
        String split = " " + operation + " ";
        int close = 0;
        if (input.startsWith("(")) {
            int open = 0;
            for (int i = 0; i < input.length(); i++) {
                if (input.charAt(i) == ')') {
                    open -= 1;
                    if (open == 0) {
                        close = i;
                        result.add(input.substring(1, i));
                        break;
                    }
                } else if (input.charAt(i) == '(') {
                    open++;
                }
            }
        } else {
            result.add(input.split(split)[0]);
        }
        if (close == 0) {
            close = result.get(0).length();

        } else {
            close++;
        }
        String right = input.substring(close + split.length());
        if (right.startsWith("(")) {
            result.add(right.substring(1, right.length() - 1));
        } else {
            result.add(right);
        }
        return result;
    }
}
