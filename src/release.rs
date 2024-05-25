use crate::common::*;

use just_release::summary as release;

impl Upgrade for release::Summary {
  type Output = Summary;

  fn upgrade(self) -> Self::Output {
    Summary {
      assignments: self.assignments.upgrade(),
      recipes: self.recipes.upgrade(),
    }
  }
}

impl Upgrade for release::Assignment {
  type Output = Assignment;

  fn upgrade(self) -> Self::Output {
    Assignment {
      exported: self.exported,
      expression: self.expression.upgrade(),
    }
  }
}

impl Upgrade for release::Recipe {
  type Output = Recipe;

  fn upgrade(self) -> Self::Output {
    Recipe {
      aliases: self.aliases,
      dependencies: self.dependencies.upgrade(),
      lines: self.lines.upgrade(),
      private: self.private,
      quiet: self.quiet,
      shebang: self.shebang,
      parameters: self.parameters.upgrade(),
    }
  }
}

impl Upgrade for release::Line {
  type Output = Line;

  fn upgrade(self) -> Self::Output {
    Line {
      fragments: self.fragments.upgrade(),
    }
  }
}

impl Upgrade for release::Fragment {
  type Output = Fragment;

  fn upgrade(self) -> Self::Output {
    match self {
      release::Fragment::Text { text } => Fragment::Text { text },
      release::Fragment::Expression { expression } => Fragment::Expression {
        expression: expression.upgrade(),
      },
    }
  }
}

impl Upgrade for release::Expression {
  type Output = Expression;

  fn upgrade(self) -> Self::Output {
    match self {
      release::Expression::Conditional {
        lhs,
        rhs,
        then,
        otherwise,
        operator,
      } => Expression::Conditional {
        lhs: Box::new(lhs.upgrade()),
        rhs: Box::new(rhs.upgrade()),
        then: Box::new(then.upgrade()),
        otherwise: Box::new(otherwise.upgrade()),
        operator: operator.upgrade(),
      },
      release::Expression::Backtick { command } => Expression::Backtick { command },
      release::Expression::Call { name, arguments } => Expression::Call {
        name,
        arguments: arguments.upgrade(),
      },
      release::Expression::Concatenation { lhs, rhs } => Expression::Concatenation {
        lhs: Box::new(lhs.upgrade()),
        rhs: Box::new(rhs.upgrade()),
      },
      release::Expression::Join { lhs, rhs } => Expression::Join {
        lhs: lhs.map(|lhs| Box::new(lhs.upgrade())),
        rhs: Box::new(rhs.upgrade()),
      },
      release::Expression::String { text } => Expression::String { text },
      release::Expression::Variable { name } => Expression::Variable { name },
    }
  }
}

impl Upgrade for release::ConditionalOperator {
  type Output = ConditionalOperator;

  fn upgrade(self) -> Self::Output {
    match self {
      Self::Equality => Self::Output::Equality,
      Self::Inequality => Self::Output::Inequality,
      Self::RegexMatch => Self::Output::RegexMatch,
    }
  }
}

impl Upgrade for release::Parameter {
  type Output = Parameter;

  fn upgrade(self) -> Self::Output {
    Parameter {
      kind: self.kind.upgrade(),
      name: self.name,
      default: self.default.upgrade(),
    }
  }
}

impl Upgrade for release::ParameterKind {
  type Output = ParameterKind;

  fn upgrade(self) -> Self::Output {
    match self {
      release::ParameterKind::Plus => ParameterKind::Plus,
      release::ParameterKind::Singular => ParameterKind::Singular,
      release::ParameterKind::Star => ParameterKind::Star,
    }
  }
}

impl Upgrade for release::Dependency {
  type Output = Dependency;

  fn upgrade(self) -> Self::Output {
    Dependency {
      recipe: self.recipe,
      arguments: self.arguments.upgrade(),
    }
  }
}
